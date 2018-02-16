class ReferencesController < ApplicationController
  include ActivitiesHelper
  include NotificationsHelper

  LOCATOR_CLASSES = {
    'doi' => DoiPaperLocator,
    'link' => LinkPaperLocator,
    'pubmed' => PubmedPaperLocator
  }
  before_action :ensure_current_user, except: :show
  before_action :set_paper_locator, only: :create

  def show
    @reference = Reference.find(params[:id])
  end

  def create
    list = List.find(reference_params[:list_id])
    list_path = user_list_path(list.owner, list)

    unless list.accepts_public_contributions? || current_user.can_edit?(list)
      return redirect_back(fallback_location: list_path, alert: 'You must be a contributor to make changes to this list.')
    end

    return redirect_back(fallback_location: list_path, alert: @locator.errors.join(' ')) unless @locator.valid?

    if (paper = @locator.find_or_import_paper)
      if Reference.exists? list_id: list.id, paper_id: paper.id
        flash['notice'] = "'#{paper.title}' has already been added to this list"
      else
        reference = Reference.create(list_id: list.id, paper_id: paper.id, user_id: current_user.id)
        flash['notice'] = "You added '#{paper.title}' to '#{list.name}'"
        create_activity_and_notifications(
          actable: reference.list,
          activity_type: "added",
          addable: reference,
          users: list.members
        )

      end
    else
      logger.debug "No paper found for: #{locator_params.inspect}"
      flash['alert'] = "Couldn't find or import a paper with those parameters"
    end
    redirect_back(fallback_location: list_path)
  end

  def destroy
    reference = Reference.find(reference_params[:id])

    unless reference.user == current_user || current_user.can_moderate?(reference.list)
      return redirect_back(fallback_location: user_list_path(reference.list.owner, reference.list), alert: 'You do not have permission to moderate this list.')
    end

    reference.destroy

    respond_to do |format|
      format.html { redirect_to user_list_path(reference.list.owner, reference.list), notice: 'Reference was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def reference_params
      params.require(:reference).permit(
        :list_id, :paper_id, :id, locator: [:id, :type, :title])
    end

    def locator_params
      reference_params[:locator]
    end

    def set_paper_locator
      locator_klass = LOCATOR_CLASSES[locator_params[:type]]

      return redirect_to(:back, alert: "Identifier can't be blank.") if locator_params[:id].blank?
      return redirect_to(:back, alert: 'Bad locator parameters') if locator_klass.nil?

      @locator = locator_klass.new locator_params
    end
end
