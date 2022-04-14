-- CREQUITASAGROREP
DELIMITER ;
DROP procedure IF EXISTS `CREQUITASAGROREP`;

DELIMITER $$

CREATE PROCEDURE `CREQUITASAGROREP`(
	-- SP del reporte de condonaciones agropecuario
	Par_FechaInicio			DATE,				-- Fecha de inicio
	Par_FechaFin 			DATE,				-- Fecha final
	Par_Sucursal			INT(11),			-- Parametro de la sucurusal
	Par_ProductoCreditoID 	INT(4),				-- Parametro del identificador del producto de credito
	Par_CreditoID 			BIGINT(12) ,		-- Numero del credito

	Par_NumLis				INT(11),			-- Numero de la lista

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario

	Aud_FechaActual			DATE,				-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Sentencia 		VARCHAR(6000);	-- Sentencia del reporte

	-- Declaracion de constantes
	DECLARE Entero_Cero 		INT(11);		-- Entero cero
	DECLARE Cadena_Vacia 		CHAR(1);		-- Cadena vacia
	DECLARE CarteraActiva 		INT(11);		-- Lista de cartera activa
	DECLARE CarteraContingente 	INT(11);		-- Lista de cartera contingente

	SET Entero_Cero 			:= 0;
	SET Cadena_Vacia 			:= '';
	SET CarteraActiva	   		:= 1;
	SET CarteraContingente 		:= 2;


	DROP TABLE IF EXISTS TMPCREQUITASCARTERAAGRO;
	CREATE TEMPORARY TABLE TMPCREQUITASCARTERAAGRO(
		FechaRegistro       date,
		GrupoID			    INT(11),		
		NombreGrupo         varchar(200), 			
		CicloGrupo          int(11),
		CreditoID           bigint(12),
		ClienteID           int(11),
		NombreCliente       varchar(200) ,
		ProductoCreditoID   int(4),
		ProductoDesc        varchar(200),
		SucursalID          int(11),
		NombreSucurs        varchar(200) ,	
		MontoCredito        decimal(12,2) ,
		UsuarioID           int(11),
		NombreUsuario       varchar(200) ,
		ClaveUsuario        varchar(45),	
		PuestoID            varchar(10),
		MontoCapital        decimal(12,4),
		MontoInteres        decimal(12,4),
		MontoMoratorios     decimal(12,4),
		MontoComisiones     decimal(12,4),
		TotalCondonado      decimal(12,4));


	-- 1.- Lista de Cartera Activa
    IF(Par_NumLis = CarteraActiva) THEN

        SET Par_Sucursal            := IFNULL(Par_Sucursal,Entero_Cero);
        SET Par_ProductoCreditoID   := IFNULL(Par_ProductoCreditoID,Entero_Cero);
        SET Par_CreditoID           := IFNULL(Par_CreditoID,Entero_Cero);

        SET Var_Sentencia :=    "INSERT INTO TMPCREQUITASCARTERAAGRO (FechaRegistro,GrupoID,NombreGrupo,CicloGrupo,CreditoID,ClienteID,NombreCliente,ProductoCreditoID,ProductoDesc,SucursalID,
                                                                      NombreSucurs,MontoCredito,UsuarioID,NombreUsuario,ClaveUsuario,PuestoID,MontoCapital,MontoInteres,MontoMoratorios,MontoComisiones,TotalCondonado)
                                                       SELECT Cqi.FechaRegistro, IFNULL(Cre.GrupoID, 0) AS GrupoID,' N/A',Cre.CicloGrupo, Cqi.CreditoID, CONVERT(LPAD(Cre.ClienteID, 8,'0'), CHAR)  AS ClienteID, ";
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' CASE WHEN Cli.TipoPersona=\"A\" or  Cli.TipoPersona=\"F\"  then');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' FNGENNOMBRECOMPLETO(Cli.PrimerNombre,Cli.SegundoNombre,Cli.TercerNombre,Cli.ApellidoPaterno,Cli.ApellidoMaterno)');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' ELSE  Cli.RazonSocial end AS NombreCliente, Cre.ProductoCreditoID, Pro.Descripcion AS ProductoDesc,');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' Cre.SucursalID,Suc.NombreSucurs , Cre.MontoCredito, Cqi.UsuarioID,');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' Usu.NombreCompleto AS NombreUsuario,Usu.Clave as ClaveUsuario, Cqi.PuestoID,');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' Cqi.MontoCapital, Cqi.MontoInteres,Cqi.MontoMoratorios, Cqi.MontoComisiones,');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' (Cqi.MontoCapital + Cqi.MontoInteres + Cqi.MontoMoratorios + Cqi.MontoComisiones) AS TotalCondonado');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' FROM  CREDITOS Cre');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN CREQUITAS Cqi on Cre.CreditoID = Cqi.CreditoID ');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN USUARIOS Usu on Usu.UsuarioID= Cqi.UsuarioID ');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN  SUCURSALES Suc on Suc.SucursalID = Cre.SucursalID');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli on Cli.ClienteID= Cre.ClienteID');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro on Pro.ProducCreditoID= Cre.ProductoCreditoID');

        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' WHERE  Cqi.FechaRegistro >= ? AND   Cqi.FechaRegistro <= ?');

        IF(Par_Sucursal!=Entero_Cero)THEN
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,'  AND  Suc.SucursalID=', CONVERT(Par_Sucursal,CHAR));
        END IF;

        IF(Par_ProductoCreditoID!=Entero_Cero)THEN
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' AND  Cre.ProductoCreditoID=', CONVERT(Par_ProductoCreditoID,CHAR));
        END IF;

        IF(Par_CreditoID!=Entero_Cero)THEN
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' AND  Cqi.CreditoID = ', CONVERT(Par_CreditoID,CHAR));
        END IF;
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' AND Pro.EsAgropecuario = "S" order by Cqi.FechaRegistro, Cre.SucursalID, Cre.ProductoCreditoID, IFNULL(Cre.GrupoID, 0), Cqi.CreditoID');

        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' ;');

        SET @Sentencia  =(Var_Sentencia);
        SET @FechaInicio    = Par_FechaInicio;
        SET @FechaFin       = Par_FechaFin;
        PREPARE STCREQUITASREP FROM @Sentencia;
        EXECUTE STCREQUITASREP USING @FechaInicio, @FechaFin;

        UPDATE TMPCREQUITASCARTERAAGRO TMP inner join GRUPOSCREDITO GRU on  TMP.GrupoID=GRU.GrupoID
        SET TMP.NombreGrupo = GRU.NombreGrupo
        WHERE  TMP.GrupoID>0;
                
        SELECT FechaRegistro,GrupoID,NombreGrupo,CicloGrupo,CreditoID,ClienteID,NombreCliente,ProductoCreditoID,ProductoDesc,SucursalID,
			   NombreSucurs,MontoCredito,UsuarioID,NombreUsuario,ClaveUsuario,PuestoID,MontoCapital,MontoInteres,MontoMoratorios,MontoComisiones,TotalCondonado
			   FROM TMPCREQUITASCARTERAAGRO;

    END IF;

    -- 2.- Lista de Cartera Contingente
    IF(Par_NumLis = CarteraContingente) THEN

        SET Par_Sucursal            := IFNULL(Par_Sucursal,Entero_Cero);
        SET Par_ProductoCreditoID   := IFNULL(Par_ProductoCreditoID,Entero_Cero);
        SET Par_CreditoID           := IFNULL(Par_CreditoID,Entero_Cero);


        SET Var_Sentencia :=    "INSERT INTO TMPCREQUITASCARTERAAGRO (FechaRegistro,GrupoID,NombreGrupo,CicloGrupo,CreditoID,ClienteID,NombreCliente,ProductoCreditoID,ProductoDesc,SucursalID,
                                                                      NombreSucurs,MontoCredito,UsuarioID,NombreUsuario,ClaveUsuario,PuestoID,MontoCapital,MontoInteres,MontoMoratorios,MontoComisiones,TotalCondonado)
                                                       SELECT Cqi.FechaRegistro, IFNULL(CreC.GrupoID, 0) AS GrupoID,' N/A',CreC.CicloGrupo, Cqi.CreditoID, CONVERT(LPAD(CreC.ClienteID, 8,'0'), CHAR)  AS ClienteID, ";
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' CASE WHEN Cli.TipoPersona=\"A\" or  Cli.TipoPersona=\"F\"  then');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' FNGENNOMBRECOMPLETO(Cli.PrimerNombre,Cli.SegundoNombre,Cli.TercerNombre,Cli.ApellidoPaterno,Cli.ApellidoMaterno)');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' ELSE  Cli.RazonSocial end AS NombreCliente, CreC.ProductoCreditoID, Pro.Descripcion AS ProductoDesc,');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' CreC.SucursalID,Suc.NombreSucurs , CreC.MontoCredito, Cqi.UsuarioID,');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' Usu.NombreCompleto AS NombreUsuario, Usu.Clave as ClaveUsuario,Cqi.PuestoID,');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' Cqi.MontoCapital, Cqi.MontoInteres,Cqi.MontoMoratorios, Cqi.MontoComisiones,');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' (Cqi.MontoCapital + Cqi.MontoInteres + Cqi.MontoMoratorios + Cqi.MontoComisiones) AS TotalCondonado');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' FROM  CREDITOSCONT CreC');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' LEFT JOIN  CREDITOS Cre ON CreC.CreditoID = Cre.CreditoID ');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN CREQUITASCONT Cqi on CreC.CreditoID = Cqi.CreditoID ');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN USUARIOS Usu on Usu.UsuarioID= Cqi.UsuarioID ');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN  SUCURSALES Suc on Suc.SucursalID = CreC.SucursalID');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli on Cli.ClienteID= CreC.ClienteID');
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro on Pro.ProducCreditoID= CreC.ProductoCreditoID');



        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' WHERE  Cqi.FechaRegistro >= ? AND   Cqi.FechaRegistro <= ?');

        IF(Par_Sucursal!=Entero_Cero)THEN
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,'  AND  Suc.SucursalID=', CONVERT(Par_Sucursal,CHAR));
        END IF;

        IF(Par_ProductoCreditoID!=Entero_Cero)THEN
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' AND  CreC.ProductoCreditoID=', CONVERT(Par_ProductoCreditoID,CHAR));
        END IF;

        IF(Par_CreditoID!=Entero_Cero)THEN
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' AND  Cqi.CreditoID = ', CONVERT(Par_CreditoID,CHAR));
        END IF;
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' AND Pro.EsAgropecuario = "S" order by Cqi.FechaRegistro, CreC.SucursalID, CreC.ProductoCreditoID, IFNULL(CreC.GrupoID, 0), Cqi.CreditoID');

        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' ;');



        SET @Sentencia  = (Var_Sentencia);
        SET @FechaInicio    = Par_FechaInicio;
        SET @FechaFin       = Par_FechaFin;
        PREPARE STCREQUITASREP FROM @Sentencia;
        EXECUTE STCREQUITASREP USING @FechaInicio, @FechaFin;
        DEALLOCATE PREPARE STCREQUITASREP;

        UPDATE TMPCREQUITASCARTERAAGRO TMP inner join GRUPOSCREDITO GRU on  TMP.GrupoID=GRU.GrupoID
        SET TMP.NombreGrupo = GRU.NombreGrupo
        WHERE  TMP.GrupoID>0;
                
        SELECT FechaRegistro,GrupoID,NombreGrupo,CicloGrupo,CreditoID,ClienteID,NombreCliente,ProductoCreditoID,ProductoDesc,SucursalID,
               NombreSucurs,MontoCredito,UsuarioID,NombreUsuario,ClaveUsuario,PuestoID,MontoCapital,MontoInteres,MontoMoratorios,MontoComisiones,TotalCondonado
               FROM TMPCREQUITASCARTERAAGRO;

    END IF;
  

END TerminaStore$$
