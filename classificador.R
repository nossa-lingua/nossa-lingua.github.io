library(openai)

textos <- yaml::read_yaml("_quarto.yml")

textos <- textos$website$sidebar$contents |> 
  unlist() |> 
  purrr::keep(\(x) stringr::str_detect(x, ".*\\.qmd")) |> 
  purrr::discard(\(x) stringr::str_detect(x, ".*index\\.qmd"))

conteudos <- textos |> 
  purrr::map(readr::read_file)


classificar_conteudo <- function(conteudo) {
  system_prompt <- "Você é um linguista muito experiente e está classificando textos de acordo com os seus gêneros literários. 
  Classifique o texto a seguir de acordo com o seu gênero literário em uma das seguintes categorias:

  Poema
  Conto
  Artigo de opinião
  Diário
  Ensaio
  Crônica
  Resenha
  História em quadrinhos  
  "

  user_message <- glue::glue("{conteudo} \n\n Resposta:")

  out <- create_chat_completion(
    model = 'gpt-3.5-turbo', 
    messages = 
      list(
        list(role = 'system', content = system_prompt),
        list(role = 'user', content = user_message)
      )
  )

  out$choices[[1]]$message$content
}