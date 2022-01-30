## Install packages

yum install words cracklib cracklib-dicts

## Update Dictionary

create-cracklib-dict /usr/share/dict/linux.words

## Add a new word to dictionary

echo 'new-word' >> /usr/share/dict/linux.words
create-cracklib-dict /usr/share/dict/linux.words

## References

https://www.thegeekdiary.com/how-to-add-words-to-the-dictionary-cracklib-uses-for-validating-passwords-against-known-dictionary-words/
