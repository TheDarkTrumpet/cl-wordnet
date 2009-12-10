USE [WordNet]
GO

/****** Object:  View [dbo].[hyponyms]    Script Date: 12/10/2009 14:41:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





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



GO

