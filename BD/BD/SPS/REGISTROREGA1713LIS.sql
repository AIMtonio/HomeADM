-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGISTROREGA1713LIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGISTROREGA1713LIS`;DELIMITER $$

CREATE PROCEDURE `REGISTROREGA1713LIS`(
# =====================================================================================
# -----       STORE DE LISTA DE REGULATORIOS A1713  		 	 ------
# ====================================================================================
	Par_NombreFuncionario   VARCHAR(250),            	-- Nombre del funcionario a buscar
	Par_Fecha               DATE,            			-- Fecha del reporte
	Par_NumLis				TINYINT UNSIGNED,			-- Tipo  de lista

	Par_EmpresaID			INT(11),					-- Parametros de Auditoria
	Aud_Usuario         	INT(11),					-- Parametros de Auditoria
	Aud_FechaActual     	DATETIME,					-- Parametros de Auditoria
	Aud_DireccionIP     	VARCHAR(15),				-- Parametros de Auditoria
	Aud_ProgramaID      	VARCHAR(50),				-- Parametros de Auditoria
	Aud_Sucursal        	INT(11),					-- Parametros de Auditoria
	Aud_NumTransaccion  	BIGINT(20)					-- Parametros de Auditoria
	)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Lis_Principal		INT(11);	-- Lista principal
	DECLARE	Cadena_Vacia		CHAR(1);	-- Cadena vacia
	DECLARE	Fecha_Vacia			DATE; 		-- Fecha vacia
	DECLARE	Entero_Cero			INT(11); 	-- Entero cero
	DECLARE MenuEntidad			INT(11);	-- Clave del Menu Entidad
    DECLARE Menu_TipoMov		INT;		-- Clave del menu tipo de movimiento

	-- Asignacion de Constantes
	SET Lis_Principal			:= 1;
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET MenuEntidad				:= 1;
    SET Menu_TipoMov			:= 17; -- Catalogos de tipos de movimiento

	IF (Par_NumLis = Lis_Principal)THEN

		SELECT	 Reg.Fecha,             Reg.RegistroID,               Reg.NombreFuncionario,
				 Reg.RFC ,                Opc.Descripcion AS TipoMovimientoID
		FROM REGISTROREGA1713 Reg, OPCIONESMENUREG Opc
		WHERE Reg.TipoMovimientoID = Opc.CodigoOpcion
        AND Reg.Fecha = Par_Fecha
        AND Opc.MenuID = Menu_TipoMov
		AND NombreFuncionario LIKE CONCAT('%',Par_NombreFuncionario,'%')
        LIMIT 15;

	END IF;

END TerminaStore$$