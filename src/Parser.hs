module Parser where

import Syntax
import Text.ParserCombinators.Parsec hiding (spaces)

--
symbol :: Parser Char
symbol = oneOf "!#$%&|*+-/:<=>?@^_~"

--
spaces :: Parser ()
spaces = skipMany1 space

--
parseString :: Parser LispVal
parseString = do
  char '"'
  x <- many (noneOf "\"")
  char '"'
  return $ String x

--
parseAtom :: Parser LispVal
parseAtom = do
  first <- letter <|> symbol
  rest <- many (letter <|> digit <|> symbol)
  let atom = first : rest
  return $ case atom of
    "#t" -> Bool True
    "#f" -> Bool False
    _ -> Atom atom

--
readExpr :: String -> String
readExpr input = case parse (spaces >> symbol) "lisp" input of
  Left err -> "No match: " ++ show err
  Right val -> "Found value" ++ show val