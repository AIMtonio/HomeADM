-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOINSTRUMENTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOINSTRUMENTOSLIS`;
DELIMITER $$


CREATE PROCEDURE `TIPOINSTRUMENTOSLIS`(

	Par_TipoInstrumentoID	varchar(50),
	Par_NumLis				INT(11),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			VARCHAR(50),
	Aud_NumTransaccion		BIGINT
	)

TerminaStore: BEGIN


	DECLARE Entero_Cero		INT(11);
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE Lis_Principal	INT(11);
	DECLARE Lis_Foranea		INT(11);
    DECLARE TipoFondeador	INT(11);

	DECLARE Lis_TipoInstru	INT(11);					-- Lista Instrumentos pantalla Activo-Inactivo Productos SAFI
	DECLARE TipoCredito		INT(11);					-- Constante Tipo Credito
	DECLARE TipoCuenta		INT(11);					-- Constante Tipo Cuenta
	DECLARE TipoCede		INT(11);					-- Constante Tipo Cede
	DECLARE TipoInversion	INT(11);					-- Constante Tipo Inversion

	DECLARE Instrum_Prospecto	INT(11);
	DECLARE Instrum_SolCred		INT(11);



	SET Entero_Cero		:= 0;
	SET Cadena_Vacia	:='';
	SET Fecha_Vacia		:='1900-01-01';
	SET Lis_Principal	:= 1;
	SET Lis_Foranea		:=2;

	SET Lis_TipoInstru	:= 3;
    SET TipoCredito		:= 11;						-- Constante Tipo Credito
	SET TipoCuenta		:= 2;						-- Constante Tipo Cuenta
	SET TipoCede		:= 28;						-- Constante Tipo Cede
	SET TipoInversion	:= 13;						-- Constante Tipo Inversion
    SET TipoFondeador	:= 12;						-- Constante Tipo Fondeador


	SET Instrum_Prospecto := 32;
	SET Instrum_SolCred := 33;

	IF(Par_NumLis = Lis_Principal)THEN
	SELECT TipoInstrumentoID, Descripcion
		FROM TIPOINSTRUMENTOS WHERE TipoInstrumentoID != Instrum_Prospecto
		AND TipoInstrumentoID != Instrum_SolCred;
	END IF;


	IF(Par_NumLis = Lis_Foranea)THEN
	SELECT TipoInstrumentoID, Descripcion
		FROM TIPOINSTRUMENTOS
			WHERE Descripcion LIKE concat("%",Par_TipoInstrumentoID,"%")
			LIMIT 15;
	END IF;

	IF(Par_NumLis = Lis_TipoInstru)THEN
	SELECT TipoInstrumentoID, Descripcion
		FROM TIPOINSTRUMENTOS
        WHERE TipoInstrumentoID
        IN(TipoCuenta,	TipoCredito,	TipoInversion,	TipoCede,	TipoFondeador);
	END IF;

END TerminaStore$$