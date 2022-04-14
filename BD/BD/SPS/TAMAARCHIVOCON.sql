-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TAMAARCHIVOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TAMAARCHIVOCON`;
DELIMITER $$

CREATE PROCEDURE  `TAMAARCHIVOCON`(
-- ===================================================================================
-- SP PARA CONSULTAR EL TAMAÑO DEL ARCHIVO
-- ===================================================================================

			Par_NumCon	 			    TINYINT UNSIGNED,           -- determinar que sección del procedimiento ejecutar

			Par_EmpresaID			INT(11),				-- Parametro de Auditoria
			Aud_Usuario				INT(11),				-- Parametro de Auditoria
			Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
			Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria
			Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
			Aud_Sucursal			INT(11),				-- Parametro de Auditoria
			Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria

)

	TerminaStore: BEGIN

		-- Declaracione de variables
		DECLARE Var_tamanarchi			VARCHAR(30);
		-- Declaracion de Constantes
		DECLARE	Cadena_Vacia			CHAR(1);
		DECLARE	Fecha_Vacia				DATE;
		DECLARE	Entero_Cero				INT;
		DECLARE SalidaSI				char(1);
		DECLARE Est_A					VARCHAR(1);
		DECLARE Est_I					VARCHAR(1);
		DECLARE Lis_Principal			INT;

		-- Asignacion de Constantes
		SET	Cadena_Vacia			:= '';				-- Cadena Vacia
		SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
		SET Entero_Cero				:= 	0;				-- Entero en Cero
		SET SalidaSI				:= 'S';				-- Salida opcion SI
		SET Est_A					:= 'A';
		SET Est_I					:= 'I';
		SET Lis_Principal			:=	1 ;
        SET Var_tamanarchi			:= 'TamanoArchivoPExp';

		IF(Par_NumCon = Lis_Principal ) THEN
			SELECT ValorParametro  FROM  PARAMGENERALES WHERE LlaveParametro= Var_tamanarchi;
		END IF;

END TerminaStore$$


