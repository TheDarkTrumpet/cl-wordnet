USE [WordNet]
GO

/****** Object:  View [dbo].[word_parse]    Script Date: 12/10/2009 14:42:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[word_parse]
as
select word.lemma,synset.synsetid,xwnparselft.parse from word
left join sense on word.wordid=sense.wordid
left join synset on sense.synsetid=synset.synsetid
left join xwnparselft on synset.synsetid=xwnparselft.synsetid

GO

