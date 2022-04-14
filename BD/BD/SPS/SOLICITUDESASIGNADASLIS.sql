	DELIMITER ;
	DROP PROCEDURE IF EXISTS `SOLICITUDESASIGNADASLIS`; 
	DELIMITER $$

	CREATE PROCEDURE `SOLICITUDESASIGNADASLIS`(
		/*SP PARA LISTAR LAS SOLICITUDES ASIGNADAS A LOS ANALISTAS DE CREDITO */
		Par_UsuarioID		VARCHAR(50),		-- Numero de Cliente
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

		DECLARE 	Var_Control	    VARCHAR(100);	-- Control de Retorno en pantalla
		DECLARE   	Lis_General	    INT;            -- Consulta solo de tipo Asignacion
		DECLARE   	Lis_PorUsuario	INT;            -- Consulta solo de tipo Asignacion
		-- Declaracion de Constantes

		DECLARE	    AnalistaVirtual	VARCHAR(20);    -- entero cero
		DECLARE	    Entero_Cero	    INT;            -- entero cero



		-- ASignacion de Constantes

		SET	Lis_General		:=1;	           -- 1 lista General
		SET	Lis_PorUsuario	:=2;	           -- 2 lista por Usuario
		SET Entero_Cero     :=0;	           -- entero cero
		SET AnalistaVirtual :='ANALISTA VIRTUAL';

		IF(IFNULL(Par_NumLis, Entero_Cero)) = Lis_General THEN
			SELECT 
			Sol.SolicitudCreditoID,       Cli.NombreCompleto AS NombreCompletoCli,       Soli.Estatus,       Soli.MontoAutorizado,      Soli.FechaRegistro,
			IFNULL(Usu.NombreCompleto,AnalistaVirtual) AS AnalistaAsignado 
			FROM SOLICITUDESASIGNADAS Sol  
			LEFT JOIN USUARIOS Usu                ON        Usu.UsuarioID=Sol.UsuarioID 
			INNER JOIN SOLICITUDCREDITO Soli      ON        Sol.SolicitudCreditoID=Soli.SolicitudCreditoID
			INNER JOIN CLIENTES Cli               ON        Soli.ClienteID=Cli.ClienteID
			WHERE    Cli.NombreCompleto LIKE CONCAT("%",Par_UsuarioID,"%")  LIMIT 0, 15;
		END IF;


		IF(IFNULL(Par_NumLis, Entero_Cero)) = Lis_PorUsuario THEN
			SELECT 
			Sol.SolicitudCreditoID,      Sol.ProductoID,      Pro.Descripcion AS DescripcionProd,        Cli.ClienteID,       Cli.NombreCompleto AS NombreCompletoCli,
			IFNULL(Usu.NombreCompleto,AnalistaVirtual) AS AnalistaAsignado,      Sol.TipoAsignacionID,       Sol.UsuarioID 
			FROM SOLICITUDESASIGNADAS Sol
			INNER JOIN SOLICITUDCREDITO Soli      ON      Sol.SolicitudCreditoID=Soli.SolicitudCreditoID
			INNER JOIN CLIENTES Cli               ON      Soli.ClienteID=Cli.ClienteID
			LEFT OUTER JOIN PRODUCTOSCREDITO Pro       ON      Sol.ProductoID=Pro.ProducCreditoID
			LEFT JOIN USUARIOS Usu                ON      Usu.UsuarioID=Sol.UsuarioID
	    	WHERE Sol.UsuarioID=Par_UsuarioID;

		END IF;
		





	END TERMINASTORE$$