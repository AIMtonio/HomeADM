-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCTOPORGRUPOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DOCTOPORGRUPOLIS`;
DELIMITER $$


CREATE PROCEDURE `DOCTOPORGRUPOLIS`(
	-- Store Procedure: Que Lista los Documentod por Grupos  en SAFI
	-- Modulo Administracion
	Par_NumList				TINYINT UNSIGNED,	-- Numero de Lista
	Par_GrupoDocumentoID	INT(11),			-- Grupo de Documento
	Par_Descripcion			VARCHAR(60),		-- Grupo de Documento

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Par_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Par_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Par_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Par_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Par_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Par_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)

TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);	-- Constante Entero Cero
	DECLARE Cadena_Vacia	CHAR(1);	-- Constante Cadena Vacia
	DECLARE ListaPrincipal	INT(11);	-- Lista de ayuda
	DECLARE ListaCombo		INT(11);	-- Lista Combo

	-- Asignacion de Constantes
	SET Entero_Cero		:= 0;
	SET Cadena_Vacia	:= '';
	SET ListaCombo		:= 1;
	SET ListaPrincipal	:= 2;

	IF( ListaCombo = Par_NumList ) THEN

		SELECT Tip.TipoDocumentoID,Tip.Descripcion
		FROM DOCTOPORGRUPO DP
		INNER JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID = DP.TipoDocumentoID
		WHERE DP.GrupoDocumentoID = Par_GrupoDocumentoID;
	END IF;

	IF( ListaPrincipal = Par_NumList ) THEN

		SELECT Tip.TipoDocumentoID,Tip.Descripcion
		FROM DOCTOPORGRUPO DP
		INNER JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID = DP.TipoDocumentoID
		WHERE  Tip.Descripcion LIKE CONCAT('%',Par_Descripcion,'%')
		  AND DP.GrupoDocumentoID = Par_GrupoDocumentoID
		LIMIT 0,15;
	END IF;
END$$