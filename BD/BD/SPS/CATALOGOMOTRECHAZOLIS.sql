	DELIMITER ;
	DROP PROCEDURE IF EXISTS `CATALOGOMOTRECHAZOLIS`; 
	DELIMITER $$

	CREATE PROCEDURE `CATALOGOMOTRECHAZOLIS`(
		/*SP PARA LISTAR MOTIVOS SOBRE CANCELACION O DEVOLUCION DE SOLICITUDES DE CREDITO */
		Par_NumLis			TINYINT UNSIGNED,	-- Numero de consulta Lsta

		-- Parametros de Auditoria
		Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
		Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
		Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
		Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
		Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
		Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
		Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
	)
	TERMINASTORE: BEGIN

		-- Declaracion de Variables
		-- Declaracion de Constantes

		DECLARE	    Entero_Cero	     INT;            -- entero cero
        DECLARE     Cancelacion      CHAR(1);        -- C Cancelado
        DECLARE     Devolucion       CHAR(1);        -- D Devolucion
        DECLARE   	Lis_Devolucion	 INT;            -- Consulta solo de tipo Asignacion
		DECLARE   	Lis_Cancelacion	 INT;            -- Consulta solo de tipo Asignacion



		-- ASignacion de Constantes

		SET	Lis_Devolucion	:= 1;	           -- 1 lista General
		SET	Lis_Cancelacion	:= 2;	           -- 2 lista por Usuario
        SET Cancelacion     := 'C';            -- C Cancelado
        SET Devolucion      := 'D';            -- D Devolucion
		SET Entero_Cero     := 0;	           -- entero cero



		IF(IFNULL(Par_NumLis, Entero_Cero)) =Lis_Cancelacion  THEN
			SELECT 
			MotivoRechazoID,     Descripcion,       TipoMotivo,      Estatus
			FROM CATALOGOMOTRECHAZO 
			WHERE TipoMotivo=Devolucion ;
		END IF;


		IF(IFNULL(Par_NumLis, Entero_Cero)) = Lis_Devolucion THEN
			SELECT 
			MotivoRechazoID,     Descripcion,       TipoMotivo,      Estatus
			FROM CATALOGOMOTRECHAZO 
			WHERE TipoMotivo=Cancelacion ;
		END IF;

	END TERMINASTORE$$