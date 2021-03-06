SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON




CREATE VIEW [dbo].[hypernyms]
AS
with word_join (wordid, lemma) as
(
	select wordid, lemma from word
)

select w1.lemma as 'hyponym', se1.rank, w2.lemma as 'hypernym'
from word w1
left join sense se1 on w1.wordid = se1.wordid
left join synset sy1 on se1.synsetid = sy1.synsetid
left join semlinkref on sy1.synsetid = semlinkref.synset1id
left join synset sy2 on semlinkref.synset2id = sy2.synsetid
left join sense se2 on sy2.synsetid = se2.synsetid
left join word_join w2 on se2.wordid = w2.wordid
where semlinkref.linkid = 1



SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON




CREATE VIEW [dbo].[hyponyms]
AS
with word_join (wordid, lemma) as
(
	select wordid, lemma from word
)

select w1.lemma as 'hypernym', se1.rank,w2.lemma as 'hyponym' from word w1 left join sense se1 on w1.wordid = se1.wordid 
left join synset sy1 on se1.synsetid = sy1.synsetid left join semlinkref on 
sy1.synsetid = semlinkref.synset1id left join synset sy2 on 
semlinkref.synset2id = sy2.synsetid left join sense se2 on sy2.synsetid = se2.synsetid 
left join word w2 on se2.wordid = w2.wordid
WHERE semlinkref.linkid = 2



SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE view [dbo].[synonyms] as
select DISTINCT w1.lemma as 'orig_word', wa.lemma as 'synonym', sy1.pos as 'grammarpos'
from word w1
left join sense se1 on w1.wordid = se1.wordid
left join synset sy1 on se1.synsetid = sy1.synsetid
left join semlinkref on sy1.synsetid = semlinkref.synset1id
left join sense se3 on sy1.synsetid = se3.synsetid
left join word wa on se3.wordid = wa.wordid
and semlinkref.linkid = 1

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON



CREATE VIEW [dbo].[verbnet_syntax]
AS
select word.lemma,synset.synsetid,vnframeref.frameid,vnexampledef.example,
vnframedef.syntax,vnframedef.semantics from word left join sense on 
word.wordid=sense.wordid left join synset on sense.synsetid=synset.synsetid 
left join vnframeref on synset.synsetid=vnframeref.synsetid and word.wordid=vnframeref.wordid
left join vnframedef on vnframeref.frameid=vnframedef.frameid 
left join vnexampleref on vnframeref.frameid=vnexampleref.frameid 
left join vnexampledef on vnexampleref.exampleid=vnexampledef.exampleid 
where synset.pos='v'


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [dbo].[word_defs] WITH SCHEMABINDING
AS
SELECT     dbo.word.lemma, dbo.synset.pos, dbo.synset.definition
FROM         dbo.word LEFT OUTER JOIN
                      dbo.sense ON dbo.word.wordid = dbo.sense.wordid LEFT OUTER JOIN
                      dbo.synset ON dbo.sense.synsetid = dbo.synset.synsetid


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
create view dbo.word_parse
as
select word.lemma,synset.synsetid,xwnparselft.parse from word
left join sense on word.wordid=sense.wordid
left join synset on sense.synsetid=synset.synsetid
left join xwnparselft on synset.synsetid=xwnparselft.synsetid

