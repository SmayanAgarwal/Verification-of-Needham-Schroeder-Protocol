-- Term Grammar
data Term = K String
    | Msg String
    | Pair Term Term
    | Enc Term String
    deriving (Show, Eq)    

-- Set Functions

listShrinkify :: Eq a => [a] -> [a]
listShrinkify l = foldr (\x s -> x: (filter (/= x) s)) [] l

setSqr :: [a] -> [(a, a)]
setSqr l = [(a, b) | a <- l, b <- l]

-- Term (and Term Set) Functions

sizeTerm :: Term -> Int
sizeTerm (Msg _) = 1
sizeTerm (K _) = 1
sizeTerm (Pair t1 t2) = 1 + sizeTerm t1 + sizeTerm t2
sizeTerm (Enc t _) = 2 + sizeTerm t

sizeTermSet :: [Term] -> Int
sizeTermSet = foldr (\t n -> (sizeTerm t) + n) 0 

subtermsTerm :: Term -> [Term]
subtermsTerm (Msg m) = [Msg m]
subtermsTerm (K k) = [K k]
subtermsTerm (Pair t1 t2) = listShrinkify((Pair t1 t2) : ((subtermsTerm t1) ++ (subtermsTerm t2)))
subtermsTerm (Enc t k) = listShrinkify ((Enc t k): (K k): ((subtermsTerm t)))

subtermsSet :: [Term] -> [Term]
subtermsSet = foldr (\t l -> (subtermsTerm t) ++ l) []

-- A Helper Function

checkDecrypt :: (Term, Term) -> Bool
checkDecrypt (Enc t k1, K k2) = (k1 == k2)
checkDecrypt _ = False

-- Derivation Rules

pairIntro :: [Term] -> [Term]
pairIntro l = listShrinkify([Pair x y | (x, y) <- setSqr l])

encIntro :: [Term] -> [Term]
encIntro l = listShrinkify([Enc t k | (t, K k) <- setSqr l])

pairElim_l :: [Term] -> [Term]
pairElim_l l = listShrinkify([x | (Pair x _) <- l])

pairElim_r :: [Term] -> [Term]
pairElim_r l = listShrinkify([y | (Pair _ y) <- l])

encElim :: [Term] -> [Term]
encElim l = listShrinkify(map (\(Enc t k1, K k2) -> t) (filter checkDecrypt (setSqr l)))

-- Proof Construction

deriveTerms :: [Term] -> [Term] -> [Term]
deriveTerms l s = 
    listShrinkify (
        l ++ encElim l 
          ++ pairElim_r l 
          ++ pairElim_l l 
          ++ filter (\t -> elem t s) (encIntro l ++ pairIntro l)
    )

deriveAllTerms :: [Term] -> [Term] -> Int -> [Term]
deriveAllTerms l s 0 = l
deriveAllTerms l s n = deriveAllTerms (deriveTerms l s) s (n-1)

derives :: [Term] -> Term -> Bool
derives x t = elem t (deriveAllTerms x (subtermsSet (t : x)) (sizeTermSet x))

-- Here is a sample for your reference: 

termList = [(Enc (Pair (Msg "m1") (K "k3")) "k3"), (K "k3")]
termToDerive = Msg "m1"

main :: IO ()
main = do
    print (derives termList termToDerive)