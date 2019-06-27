export const citeText = (paper) => {
  let mainAuthor = ''
  let year = ''
  let pub = ''

  if (! paper) return '[not found]'

  if (paper.authors.length > 0) {
    mainAuthor = paper.authors[0].family_name
    if (mainAuthor.length > 50) {
      mainAuthor = mainAuthor.substring(0, 50) + '...'
    }
  }
  if (paper.published_at != null) {
    year = new Date(paper.published_at).getFullYear()
  }
  if (paper.publication != null) {
    pub = paper.publication
    if (pub.length > 50) {
      pub = pub.substring(0, 50) + '...'
    }
  }
  const joinedCitation = $.grep([year, mainAuthor, pub], Boolean).join(', ');

  if (pub != '' || year != '') {
    return '[' + joinedCitation + ']'
  }
}

export const getPaper = (list, id) => {
  if (! id || ! list) return null
  id = parseInt(id)
  let paper

  list.posts.find((post) => {
    return post.articles.find(article => {
      return article.papers.find(p => {
        if (p.id === id) {
          paper = p
          return p
        }
      })
    })
  })

  return paper
}