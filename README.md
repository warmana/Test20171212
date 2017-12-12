# Test20171212
Try out Travis build

The basic way to spell check a file is:
`cat some_text.md | aspell -a  | grep -v '^[\*@]' | grep -v '^$' | cut -f2 -d ' '`

Using a local dictionary to allow through local words.
`cat some_text.md | aspell -a --personal=./localDictionary.en.pws | grep -v '^[\*@]' | grep -v '^$' | cut -f2 -d ' '`

Force a spelling mitsake.