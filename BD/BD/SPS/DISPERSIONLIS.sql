-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before AND after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONLIS`;
DELIMITER $$

CREATE PROCEDURE `DISPERSIONLIS`(
	/* LISTA DE DISPERSIONES*/
	Par_InstitucionID		VARCHAR(20),
	Par_NumLis				tinyint unsigned,

	Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT;
DECLARE	EstatusAbierto			CHAR(1);
DECLARE	Lis_EstAbierto 			INT;
DECLARE Lis_DisperAExpor		INT;
DECLARE	FormaPagSpei			INT;
DECLARE EstatusAutorizado		CHAR(1);
DECLARE Cons_Santander			INT(11);
DECLARE FormaPagOrdPag			INT(11);

SET	Cadena_Vacia				:= '';
SET	Fecha_Vacia					:= '1900-01-01';
SET	Entero_Cero					:= 0;
SET	EstatusAbierto				:= 'A';
SET	Lis_EstAbierto				:= 1;
SET Lis_DisperAExpor 			:= 2;
SET FormaPagSpei				:=1;
SET EstatusAutorizado			:='A';
SET Cons_Santander				:= 28;
SET FormaPagOrdPag				:= 5;

IF(Par_NumLis = Lis_EstAbierto) THEN
	SELECT FolioOperacion,	IT.NombreCorto,	NumCtaInstit, FechaOperacion
		FROM	DISPERSION DI,
			INSTITUCIONES IT
		WHERE  IT.NombreCorto LIKE concat("%", Par_InstitucionID, "%")
		AND    DI.InstitucionID	= IT.InstitucionID
		AND    DI.Estatus 		= EstatusAbierto
		ORDER BY FolioOperacion DESC
		LIMIT 15;

END IF;

IF(Par_NumLis = Lis_DisperAExpor) THEN
	SELECT DISTINCT(FolioOperacion),	IT.NombreCorto,	NumCtaInstit, FechaOperacion
		FROM	DISPERSION DI
				INNER JOIN INSTITUCIONES IT ON DI.InstitucionID	= IT.InstitucionID
				INNER JOIN DISPERSIONMOV Mov ON DI.FolioOperacion = Mov.DispersionID
							AND CASE DI.InstitucionID WHEN Cons_Santander THEN FormaPago = FormaPagOrdPag ELSE FormaPago = FormaPagSpei END
							AND Mov.Estatus IN(EstatusAutorizado,'E')
		WHERE  IT.NombreCorto LIKE concat("%", Par_InstitucionID, "%")
		ORDER BY FolioOperacion DESC
		LIMIT 15;

END IF;

END TerminaStore$$