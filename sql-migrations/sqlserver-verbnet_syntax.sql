USE [WordNet]
GO

/****** Object:  View [dbo].[verbnet_syntax]    Script Date: 12/10/2009 14:41:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




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


GO

