# Verification-of-Needham-Schroeder-Protocol

This is code that I had written for my Information Security course. We had been asked to verify the Needham-Schroeder Protocol. I did the project in Haskell to become more familiar with it.


It checks whether a target term can be derived from an initial knowledge set using simple inference rules such as pairing, encryption, projection, and decryption.

The system follows a natural-deduction style approach. In particular, it includes both introduction rules and elimination rules. Pairing and encryption act like introduction rules, while projection from pairs and decryption act like elimination rules.

The term language contains four kinds of objects: messages, keys, pairs of terms, and encrypted terms.

The derivation process starts from an initial knowledge set and repeatedly generates new terms that can be obtained from the rules. A target term is considered derivable if it appears in the closure of that initial set under the derivation rules.

In the sample example, the system is given an encrypted pair together with the matching key, and it correctly derives the message inside by first decrypting the ciphertext and then projecting the left component of the pair.

This project is useful as a simple model of derivability, symbolic reasoning, and proof search over structured terms.
