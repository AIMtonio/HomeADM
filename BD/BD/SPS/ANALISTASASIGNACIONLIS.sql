DELIMITER ;
DROP PROCEDURE IF EXISTS `ANALISTASASIGNACIONLIS`; 
DELIMITER $$

CREATE PROCEDURE `ANALISTASASIGNACIONLIS`(

	Par_NumLis			TINYINT UNSIGNED,	-- Numero de consulta Lsta
	Par_TipoAsignacionID      	INT(11),	-- Indica  el tipo de asignacion 
	Par_ProductoID              INT(11),    -- ID del producto


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

    DECLARE 	Var_Control		VARCHAR(100);	-- Control de Retorno en pantalla

    DECLARE   	Lis_TipoAsignacion	INT;        -- Consulta solo de tipo Asignacion
    DECLARE	    Entero_Cero	    INT;            -- entero cero
    DECLARE     Cadena_Vacia    CHAR(1);
	-- Declaracion de Constantes


	-- ASignacion de Constantes

    SET	Lis_TipoAsignacion		:=1;	           -- 1 lista por Aasignacion
	SET Entero_Cero             :=0;	           -- entero cero
	SET Cadena_Vacia    		:='';              -- cadena vacia

	IF(IFNULL(Par_NumLis, Entero_Cero)) = Lis_TipoAsignacion THEN
		SELECT 
		Usu.Clave,         Usu.NombreCompleto,            Usu.UsuarioID,            Ana.ProductoID

		FROM USUARIOS Usu
		INNER JOIN ANALISTASASIGNACION Ana                ON        Usu.UsuarioID=Ana.UsuarioID
		WHERE Ana.TipoAsignacionID=Par_TipoAsignacionID   AND       Ana.ProductoID=Par_ProductoID;
	END IF;
	





END TerminAStore$$