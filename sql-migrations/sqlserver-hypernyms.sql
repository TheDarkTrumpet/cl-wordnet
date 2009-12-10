USE [WordNet]
GO

/****** Object:  View [dbo].[hypernyms]    Script Date: 12/10/2009 14:41:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





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



GO

