USE [WordNet]
GO

/****** Object:  View [dbo].[synonyms]    Script Date: 12/10/2009 14:41:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[synonyms] as
select DISTINCT w1.lemma as 'orig_word', wa.lemma as 'synonym',  sy1.pos, c.name as grammarpos, sy1.definition from 
word w1 left join sense se1 on w1.wordid = se1.wordid left join synset sy1 on se1.synsetid = sy1.synsetid
left join categorydef c ON sy1.categoryid = c.categoryid
left join semlinkref on sy1.synsetid = semlinkref.synset1id 
left join sense se3 on sy1.synsetid = se3.synsetid left join word wa on se3.wordid = wa.wordid

GO

