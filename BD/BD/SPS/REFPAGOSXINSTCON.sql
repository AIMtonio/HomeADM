-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFPAGOSXINSTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REFPAGOSXINSTCON`;DELIMITER $$

CREATE PROCEDURE `REFPAGOSXINSTCON`(
/* LISTA EL CATALOGO DE PAISES DE LA GAFI */
	Par_TipoCanalID				INT(11), 		-- ID del tipo de canal sólo para ctas y creditos. Corresponde a TIPOCANAL
	Par_InstrumentoID			BIGINT(20), 	-- ID del instrumento (CuentaAhoID, CreditoID).
	Par_Origen					INT(11), 		-- Instituciones Bancarias 1.- Instituciones.
	Par_InstitucionID			INT(11), 		-- ID de INSTITUCIONES.
	Par_NombInstitucion			VARCHAR(100),	-- Nombre largo de la Institucion o del Tercero.

	Par_Referencia				VARCHAR(45),	-- Nombre de la Rerferencia (Alfanumérico).
	Par_TipoConsulta			TINYINT,		-- Numero de consulta
    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	SalidaSI        	CHAR(1);
DECLARE	SalidaNO        	CHAR(1);
DECLARE	StrSI        		CHAR(1);
DECLARE	StrNO        		CHAR(1);
DECLARE	ConsultaPrincipal	INT(11);
DECLARE	ConsultaForanea 	INT(11);
DECLARE	TipoCanalCred   	INT(11);
DECLARE	TipoCanalCtas		INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET	StrSI        		:= 'S';				-- Constante Si
SET	StrNO        		:= 'N'; 			-- Constante No
SET	ConsultaPrincipal   := 1; 				-- Consulta Principal
SET	ConsultaForanea   	:= 2; 				-- Consulta Foranea
SET	TipoCanalCred       := 1; 				-- Tipo de Canal para Creditos
SET	TipoCanalCtas		:= 2;				-- Tipo de Canal para Cuentas

/* Consulta No. 1
 * Busca coincidencias en las referencias y devuelve el numero de cuenta de ahorro.
 * Usada antes de llamar al SP-DEPCUENTASVAL en la clase DAO.
*/
IF(IFNULL(Par_TipoConsulta, Entero_Cero)) = ConsultaPrincipal THEN
	IF(EXISTS(SELECT RefPagoID
      FROM REFPAGOSXINST
		WHERE Referencia = IFNULL(Par_Referencia,Cadena_Vacia) AND TipoCanalID=TipoCanalCtas
			AND InstitucionID = Par_InstitucionID))THEN

			SELECT StrSI AS Existe, InstrumentoID
			  FROM REFPAGOSXINST R
				WHERE Referencia = IFNULL(Par_Referencia,Cadena_Vacia)
					AND TipoCanalID = TipoCanalCtas
                    AND InstitucionID = Par_InstitucionID;
	ELSE
		SELECT StrNO AS Existe, Entero_Cero AS InstrumentoID;
	END IF;
END IF;

/* Consulta No. 2
 * Busca coincidencias en las referencias
 * Usada en pantalla de Regsitro de Referencias por Instrumento
*/
IF(IFNULL(Par_TipoConsulta, Entero_Cero)) = ConsultaForanea THEN
	IF(EXISTS(SELECT RefPagoID
      FROM REFPAGOSXINST
		WHERE Referencia = IFNULL(Par_Referencia,Cadena_Vacia) AND TipoCanalID=Par_TipoCanalID
			AND InstitucionID = Par_InstitucionID))THEN

			SELECT StrSI AS Existe, InstrumentoID
			  FROM REFPAGOSXINST R
				WHERE Referencia = IFNULL(Par_Referencia,Cadena_Vacia)
					AND TipoCanalID = Par_TipoCanalID
                    AND InstitucionID = Par_InstitucionID;
	ELSE
		SELECT StrNO AS Existe, Entero_Cero AS InstrumentoID;
	END IF;
END IF;

END TerminaStore$$