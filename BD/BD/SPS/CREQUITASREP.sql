-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREQUITASREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREQUITASREP`;
DELIMITER $$

CREATE PROCEDURE `CREQUITASREP`(
	-- SP del reporte quitas y condonacion
	Par_FechaInicio			DATE,				-- Fecha de inicio
	Par_FechaFin 			DATE,				-- Fecha final
	Par_Sucursal			INT(11),			-- Parametro de la sucurusal
	Par_ProductoCreditoID 	INT(4),				-- Parametro del identificador del producto de credito
	Par_CreditoID 			BIGINT(12) ,		-- Numero del credito
	Par_InstitucionID 		INT(11), -- parametro atraso final
    Par_ConvenioNominaID	BIGINT UNSIGNED, -- Numero del Convenio de Nomina
    
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
    DECLARE EsNomina           	CHAR(1); 		-- Producto de nomina
    DECLARE Cons_No           	CHAR(1); 		-- Constante NO
    DECLARE Cons_Si           	CHAR(1); 		-- Constante SI

	SET Entero_Cero 			:= 0;
	SET Cadena_Vacia 			:= '';
	SET Par_Sucursal            := IFNULL(Par_Sucursal,Entero_Cero);
	SET Par_ProductoCreditoID   := IFNULL(Par_ProductoCreditoID,Entero_Cero);
	SET Par_CreditoID           := IFNULL(Par_CreditoID,Entero_Cero);
	SET Cons_No           		:= 'N';
	SET Cons_Si           		:= 'S';
    SET Var_Sentencia			:= Cadena_Vacia;
    SET EsNomina		:= (SELECT ProductoNomina 
								FROM PRODUCTOSCREDITO 
                                WHERE ProducCreditoID = Par_ProductoCreditoID);
	SET EsNomina		:= IFNULL(EsNomina, Cons_No);
    
    DROP TABLE IF EXISTS TMPCREQUITASREP;
	CREATE TEMPORARY TABLE TMPCREQUITASREP(
	  `FechaRegistro` 		DATE,
	  `GrupoID` 			BIGINT(11),
	  `NombreGrupo` 		VARCHAR(200),
	  `CicloGrupo` 			INT(11),
	  `CreditoID` 			BIGINT(20),
	  `ClienteID` 			INT(11),
	  `NombreCliente` 		VARCHAR(200),
	  `ProductoCreditoID` 	INT(11),
	  `ProductoDesc` 		VARCHAR(100),
	  `SucursalID` 			INT(11),
	  `NombreSucurs` 		VARCHAR(50),
	  `MontoCredito` 		DECIMAL(12,2),
	  `UsuarioID` 			INT(11),
	  `NombreUsuario` 		VARCHAR(150),
	  `ClaveUsuario` 		VARCHAR(45),
	  `PuestoID` 			VARCHAR(50),
	  `MontoCapital` 		DECIMAL(14,2),
	  `MontoInteres` 		DECIMAL(14,2),
	  `MontoMoratorios` 	DECIMAL(14,2),
	  `MontoComisiones` 	DECIMAL(14,2),
	  `MontoNotasCargo` 	DECIMAL(14,2),
	  `TotalCondonado` 		DECIMAL(17,2),
	  `ProductoNomina` 		CHAR(1),
	  `InstitucionNominaID` INT(11),
	  `ConvenioNominaID` 	INT(11)
	);
	SET Var_Sentencia :=	"INSERT INTO TMPCREQUITASREP (
									FechaRegistro,			GrupoID,			NombreGrupo,			CicloGrupo,			CreditoID,
									ClienteID,				NombreCliente,		ProductoCreditoID,		ProductoDesc,		SucursalID,
									NombreSucurs,			MontoCredito,		UsuarioID,				NombreUsuario,		ClaveUsuario,
									PuestoID,				MontoCapital,		MontoInteres,			MontoMoratorios,	MontoComisiones,
									MontoNotasCargo,		TotalCondonado,			ProductoNomina,		InstitucionNominaID,ConvenioNominaID)
							";
    
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,"SELECT Cqi.FechaRegistro, IFNULL(Gpo.GrupoID, 0) AS GrupoID, IFNULL(Gpo.NombreGrupo, '') AS NombreGrupo,
                                    Cre.CicloGrupo, Cqi.CreditoID, CONVERT(LPAD(Cre.ClienteID, 8,'0'), CHAR)  AS ClienteID, ");
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' CASE WHEN Cli.TipoPersona="A" or  Cli.TipoPersona="F" then');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' FNGENNOMBRECOMPLETO(Cli.PrimerNombre,Cli.SegundoNombre,Cli.TercerNombre,Cli.ApellidoPaterno,Cli.ApellidoMaterno)');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' ELSE  Cli.RazonSocial end AS NombreCliente, Cre.ProductoCreditoID, Pro.Descripcion AS ProductoDesc,');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' Cre.SucursalID,Suc.NombreSucurs , Cre.MontoCredito, Cqi.UsuarioID,');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' Usu.NombreCompleto AS NombreUsuario,Usu.Clave as ClaveUsuario, Cqi.PuestoID,');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' Cqi.MontoCapital, Cqi.MontoInteres,Cqi.MontoMoratorios, Cqi.MontoComisiones, IFNULL(Cqi.MontoNotasCargo,0),');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' (Cqi.MontoCapital + Cqi.MontoInteres + Cqi.MontoMoratorios + Cqi.MontoComisiones +  IFNULL(Cqi.MontoNotasCargo,0)) AS TotalCondonado, Pro.ProductoNomina, ');
    IF(Par_ProductoCreditoID!=0 AND EsNomina = Cons_Si)THEN
		SET Var_Sentencia :=	CONCAT(Var_Sentencia,' Nomi.InstitNominaID AS InstitucionNominaID, Nomi.ConvenioNominaID AS ConvenioNominaID ');
	ELSE
		SET Var_Sentencia :=    CONCAT(Var_Sentencia, Entero_Cero,' AS InstitucionNominaID,', Entero_Cero,' AS ConvenioNominaID ');
	END IF;
    
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' FROM  CREDITOS Cre');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' LEFT JOIN GRUPOSCREDITO Gpo on Gpo.GrupoID = Cre.GrupoID ');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN CREQUITAS Cqi on Cre.CreditoID = Cqi.CreditoID ');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN USUARIOS Usu on Usu.UsuarioID= Cqi.UsuarioID ');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN  SUCURSALES Suc on Suc.SucursalID = Cre.SucursalID');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli on Cli.ClienteID= Cre.ClienteID');
    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro on Pro.ProducCreditoID= Cre.ProductoCreditoID');
	IF(Par_ProductoCreditoID!=0 AND EsNomina = Cons_Si)THEN
		-- VALIDACION DE PRODUCTO DE NOMINA       
        IF( EsNomina = Cons_Si) THEN
			IF(IFNULL(Par_InstitucionID,Entero_Cero) != Entero_Cero) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN NOMCONDICIONCRED Nomi ON Pro.ProducCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID AND Nomi.InstitNominaID = ',Par_InstitucionID);
			 ELSE
				SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN NOMCONDICIONCRED Nomi ON Pro.ProducCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID ');
			END IF;
		
			IF(IFNULL(Par_ConvenioNominaID,Entero_Cero) != Entero_Cero) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Nomi.ConvenioNominaID = ',Par_ConvenioNominaID);
			END IF;
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA InstNom ON Nomi.InstitNominaID = InstNom.InstitNominaID ');
		END IF;
	END IF;


    SET Var_Sentencia :=    CONCAT(Var_Sentencia,' WHERE  Cqi.FechaRegistro >= ? AND  Cqi.FechaRegistro <= ?');

    IF(Par_Sucursal!=Entero_Cero)THEN
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,'  AND Suc.SucursalID=', CONVERT(Par_Sucursal,CHAR));
    END IF;

    IF(Par_ProductoCreditoID!=Entero_Cero)THEN
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' AND Cre.ProductoCreditoID=', CONVERT(Par_ProductoCreditoID,CHAR));
    END IF;

    IF(Par_CreditoID!=Entero_Cero)THEN
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,' AND Cqi.CreditoID = ', CONVERT(Par_CreditoID,CHAR));
    END IF;
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,'  AND Pro.EsAgropecuario != "S" order by Cqi.FechaRegistro, Cre.SucursalID, Cre.ProductoCreditoID, IFNULL(Gpo.GrupoID, 0), Cqi.CreditoID');

	SET Var_Sentencia :=    CONCAT(Var_Sentencia,' ;');

    SET @Sentencia  = (Var_Sentencia);
    SET @FechaInicio    = Par_FechaInicio;
    SET @FechaFin       = Par_FechaFin;



   PREPARE STCREQUITASREP FROM @Sentencia;
   EXECUTE STCREQUITASREP USING @FechaInicio, @FechaFin;
   DEALLOCATE PREPARE STCREQUITASREP;
   
   -- ACTUALIZAMOS LOS DATOS DE INSTITUCION DE NOMINA
	UPDATE TMPCREQUITASREP TMP
	INNER JOIN CREDITOS Cre on TMP.CreditoID=Cre.CreditoID
	INNER JOIN NOMCONDICIONCRED Nomi ON TMP.ProductoCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID
		SET TMP.InstitucionNominaID =  Nomi.InstitNominaID,
			TMP.ConvenioNominaID	 = Nomi.ConvenioNominaID
	WHERE TMP.ProductoNomina= Cons_Si
	AND TMP.InstitucionNominaID = Entero_Cero;
	-- FIN ACTUALIZACION LOS DATOS DE INSTITUCION DE NOMINA

    SELECT  FechaRegistro,			GrupoID,			NombreGrupo,			CicloGrupo,			CreditoID,
			ClienteID,				NombreCliente,		ProductoCreditoID,		ProductoDesc,		SucursalID,
			NombreSucurs,			MontoCredito,		UsuarioID,				NombreUsuario,		ClaveUsuario,
			PuestoID,				MontoCapital,		MontoInteres,			MontoMoratorios,	MontoComisiones,
			TotalCondonado,			ProductoNomina,		InstitucionNominaID,	ConvenioNominaID,	MontoNotasCargo
	FROM TMPCREQUITASREP;
    
    DROP TABLE IF EXISTS TMPCREQUITASREP;
END TerminaStore$$
