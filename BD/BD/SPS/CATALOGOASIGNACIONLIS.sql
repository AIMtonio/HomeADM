DELIMITER ;
DROP PROCEDURE IF EXISTS `CATALOGOASIGNACIONLIS`; 
DELIMITER $$

CREATE PROCEDURE `CATALOGOASIGNACIONLIS`(

	Par_NumLis			TINYINT UNSIGNED,	-- Numero de consulta
	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminAStore: BEGIN

	-- Declaracion de Variables
    DECLARE 	Lis_Catalogo	INT(11);	-- Lista para los catalogos generales
    DECLARE	    Entero_Cero	    INT;        -- Consulta solo de tipo perfil analista
	-- Declaracion de Constantes


	-- ASignacion de Constantes
    SET	Lis_Catalogo			:=1;	            -- 1 lista para tipo Ejecutivos
	SET Entero_Cero             :=0;	            -- entero cero





	IF(IFNULL(Par_NumLis, Entero_Cero)) = Lis_Catalogo THEN
		SELECT TipoAsignacionID,Descripcion
		FROM CATASIGNASOLICITUD ;
	END IF;
	



END TerminAStore$$