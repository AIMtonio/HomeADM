-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDESCREDAGROREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDESCREDAGROREP`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDESCREDAGROREP`(
/*SP PARA GENERAR EL REPORTE DE SOLICITUDES DE CREDITOS GENERADAS*/
	Par_FechaInicio		DATE,			-- fecha de inicio
	Par_FechaFin		DATE,			-- fecha de fin del reporte
	Par_SucursalID		INT(11),		-- Sucursal de solicitudes
	Par_UsuarioID		INT(11),		-- usuarios de solicitudes
	Par_ProducCreditoID	INT(11),		-- productos de credito

    Par_ClienteID		INT(11),		-- Numero de cliente
    Par_ProspectoID		INT(11),		-- Id del prospecto
    Par_Estatus			CHAR(1),

    Par_EmpresaID       INT(11),		-- Auditoria
    Aud_Usuario         INT(11),        -- Auditoria
    Aud_FechaActual     DATETIME,       -- Auditoria

    Aud_DireccionIP     VARCHAR(15),	-- Auditoria
    Aud_ProgramaID      VARCHAR(50),    -- Auditoria
    Aud_Sucursal        INT(11),        -- Auditoria
    Aud_NumTransaccion  BIGINT(20)		-- Auditoria
)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_Sentencia   VARCHAR(3000);
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE Todas			CHAR(1);
	DECLARE Es_EsAgro		CHAR(1);
	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET Todas				:= 'T';
	SET Es_EsAgro			:= 'S';

	SET Var_Sentencia := CONCAT(
								" SELECT distinct Usu.UsuarioID,Usu.NombreCompleto as NombreUsuario, ",
								" CONCAT((CASE WHEN Cli.ClienteID IS NULL THEN '' ELSE  LPAD(Cli.ClienteID,10,0) END),'/',IF(Cli.ClienteID IS NOT NULL AND Pr.ProspectoID IS NOT NULL, '\n',''), ",
								" (CASE WHEN Pr.ProspectoID IS NULL THEN '' ELSE  LPAD(Pr.ProspectoID,10,0) END)) as ClienteID,",
								" UPPER(CASE WHEN Cli.ClienteID IS NOT NULL THEN Cli.NombreCompleto ELSE Pr.NombreCompleto END) AS NombreCompleto,",
								" Sol.SolicitudCreditoID,Sol.FechaInicio,CASE Sol.Estatus WHEN 'I' THEN 'INACTIVA'",
																			  "WHEN 'L' THEN 'LIBERADA'",
																			  "WHEN 'A' THEN 'AUTORIZADA'",
																			  "WHEN 'C' THEN 'CANCELADA'",
																			  "WHEN 'R' THEN 'RECHAZADA'",
																			  "WHEN 'D' THEN 'DESEMBOLSADA' END AS Estatus,",
								                                              "Sol.MontoSolici, Pro.ProducCreditoID,Pro.Descripcion, Sol.TasaFija, Sol.UsuarioAltaSol",
								" FROM SOLICITUDCREDITO Sol",
									" INNER JOIN PRODUCTOSCREDITO Pro ON Pro.ProducCreditoID=Sol.ProductoCreditoID ",
									" INNER JOIN USUARIOS Usu ON Usu.UsuarioID=Sol.UsuarioAltaSol",
									" LEFT JOIN CLIENTES AS Cli ON Sol.ClienteID=Cli.ClienteID",
									" LEFT JOIN PROSPECTOS AS Pr	ON Sol.ProspectoID=Pr.ProspectoID ");
	SET Var_Sentencia:=CONCAT(Var_Sentencia,' WHERE Sol.FechaInicio BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,' ','" AND Sol.EsAgropecuario= "',Es_EsAgro,'" ');

	-- Filtro por sucursal
	SET Par_SucursalID:=IFNULL(Par_SucursalID,Entero_Cero);
	IF(Par_SucursalID!=Entero_Cero)THEN
		SET Var_Sentencia :=  CONCAT( Var_Sentencia,' AND Sol.SucursalID= ',Par_SucursalID);
	END IF;

	-- Filtro por Usuario
	SET Par_UsuarioID := IFNULL(Par_UsuarioID,Entero_Cero);
	IF(Par_UsuarioID!=Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND Sol.UsuarioAltaSol= ',Par_UsuarioID);
	END IF;

	-- Filtro por Producto
	SET Par_ProducCreditoID := IFNULL(Par_ProducCreditoID,Entero_Cero);
	IF(Par_ProducCreditoID!=Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND Sol.ProductoCreditoID=',Par_ProducCreditoID);
	END IF;

	-- Filtro por Cliente
	SET Par_ClienteID := IFNULL(Par_ClienteID,Entero_Cero);
	IF(Par_ClienteID>Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND Sol.ClienteID=',Par_ClienteID);
	END IF;

	-- Filtro por prospecto
	SET Par_ProspectoID := IFNULL(Par_ProspectoID,Entero_Cero);
	IF(Par_ProspectoID>Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND Sol.ProspectoID=',Par_ProspectoID);
	END IF;

	-- Filtro por Estatus
	SET Par_Estatus := IFNULL(Par_Estatus,Cadena_Vacia);
	IF(Par_Estatus!=Cadena_Vacia AND Par_Estatus!=Todas)THEN
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND Sol.Estatus= "',Par_Estatus,'"');
	END IF;

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' order by Sol.UsuarioAltaSol, Sol.FechaInicio ');

	SET @Sentencia	= (Var_Sentencia);

	PREPARE STSOLICITUDESCREDREP FROM @Sentencia;
	EXECUTE STSOLICITUDESCREDREP ;
	DEALLOCATE PREPARE STSOLICITUDESCREDREP;

END TerminaStore$$