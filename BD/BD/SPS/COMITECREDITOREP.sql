-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMITECREDITOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMITECREDITOREP`;DELIMITER $$

CREATE PROCEDURE `COMITECREDITOREP`(
    Par_SucursalID      INT (11),
    Par_Fecha           DATE,
    Par_TipoReporte     INT (11),

    Par_EmpresaID       INT (11),
    Aud_Usuario         INT (11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT (11),
    Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN


DECLARE Var_NomInstit   VARCHAR(300);
DECLARE Var_NomSucurs   VARCHAR(200);
DECLARE Var_FecConsejo  DATE;
DECLARE Var_UsuNombre   VARCHAR(300);
DECLARE Var_NomAutori   VARCHAR(3000);

DECLARE Var_Folio       BIGINT;
DECLARE Var_Registros	INT(11);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT (11);
DECLARE Salida_NO       CHAR(1);
DECLARE Sta_Autorizada  CHAR(1);

DECLARE Sta_Desembol    CHAR(1);
DECLARE Sta_Inactivo    CHAR(1);
DECLARE Sta_Cancelado   CHAR(1);
DECLARE Monto_Mayores   DECIMAL(12,2);
DECLARE Rel_Empleado    INT (11);

DECLARE Rep_EncSucurs   INT (11);
DECLARE Rep_DetSucurs   INT (11);
DECLARE Rep_Enc60Mil    INT (11);
DECLARE Rep_Det60Mil    INT (11);
DECLARE Rep_EncPerRel   INT (11);

DECLARE Rep_DetPerRel   INT (11);
DECLARE Rep_EncReestr   INT (11);
DECLARE Rep_DetReestr   INT (11);
DECLARE Acta_Sucursal   CHAR(1);
DECLARE Acta_CreMayores CHAR(1);

DECLARE Acta_Relaciona  CHAR(1);
DECLARE Acta_Reestruc   CHAR(1);
DECLARE FechaNombre		CHAR(50);


DECLARE Clas_Empleado   CHAR(1);
DECLARE Clas_Funcionario   CHAR(1);
DECLARE Tipo_Nuevo	    CHAR(1);
DECLARE Par_NumErr 		INT (11);
DECLARE Par_ErrMen  	VARCHAR(350);

DECLARE Tipo_Renovado	CHAR(1);
DECLARE Tipo_Reestruc	CHAR(1);
DECLARE Sta_Vigente	    CHAR(1);
DECLARE Sta_Vencido     CHAR(1);


-- CURSOR USADO EN LA SECCION Rep_EncSucurs PARA ENCABEZADO DE REPORTE DE SUCURSAL
DECLARE CURSORCRESUCURS CURSOR FOR
	SELECT DISTINCT(Usu.NombreCompleto)
    FROM SOLICITUDCREDITO Sol
		INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
		INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Fir.OrganoID IN(1,2,5)
		INNER JOIN USUARIOS Usu ON Usu.UsuarioID = Fir.UsuarioFirma
    WHERE (Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
      AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
      AND Sol.FechaAutoriza = Par_Fecha
      AND Sol.SucursalID    = Par_SucursalID;


-- CURSOR USADO EN LA SECCION Rep_Enc60Mil PARA ENCABEZADO DE REPORTE DE COMITE CENTRAL
	DECLARE CURSORCREMAYORES CURSOR FOR
	SELECT DISTINCT(Usu.NombreCompleto)
    FROM SOLICITUDCREDITO Sol
		INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
		INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Fir.OrganoID IN(3,4,6)
		INNER JOIN USUARIOS Usu ON Usu.UsuarioID = Fir.UsuarioFirma
    WHERE(Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
      AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
      AND Sol.FechaAutoriza = Par_Fecha
      AND Sol.TipoCredito=Tipo_Nuevo
	  AND Sol.ClienteID NOT IN  (  SELECT Rel.ClienteID
											FROM RELACIONCLIEMPLEADO Rel
											WHERE Rel.ClienteID = Sol.ClienteID
											  AND Rel.TipoRelacion = Rel_Empleado);

--  CURSOR USADO EN LA SECCION Rep_EncReestr PARA ENCABEZADO DE REPORTE DE REESTRUCTURAS Y RENOVACIONES
	DECLARE CURSORREESTRUC CURSOR FOR
		SELECT DISTINCT(Usu.NombreCompleto)
			FROM SOLICITUDCREDITO Sol
			INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
			INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
			INNER JOIN USUARIOS Usu ON Usu.UsuarioID = Fir.UsuarioFirma
			WHERE (Sol.Estatus  = Sta_Autorizada OR Sol.Estatus  = Sta_Desembol)
			  AND (Sol.TipoCredito=Tipo_Renovado OR Sol.TipoCredito=Tipo_Reestruc)
			  AND Sol.FechaAutoriza = Par_Fecha;


--  CURSOR USADO EN LA SECCION Rep_EncPerRel PARA ENCABEZADO DE REPORTE DE PERSONAS RELACIONADAS
	DECLARE CURSORCRERELACI CURSOR FOR
	(SELECT DISTINCT(Usu.NombreCompleto)
		FROM SOLICITUDCREDITO Sol
		INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
		INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Fir.OrganoID IN(3,4,6)
		INNER JOIN USUARIOS Usu ON Usu.UsuarioID = Fir.UsuarioFirma
		WHERE (Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
		  AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
		  AND Sol.FechaAutoriza = Par_Fecha
		  AND Sol.ClienteID  IN  ( SELECT DISTINCT(Rel.ClienteID )
											FROM RELACIONCLIEMPLEADO Rel
											WHERE Rel.ClienteID = Sol.ClienteID
												  AND Rel.TipoRelacion = Rel_Empleado ))
	UNION

	(SELECT DISTINCT(Usu.NombreCompleto)
		FROM SOLICITUDCREDITO Sol
		INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
		INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Fir.OrganoID IN(3,4,6)
		INNER JOIN USUARIOS Usu ON Usu.UsuarioID = Fir.UsuarioFirma
		INNER JOIN CLIENTES Cli ON Sol.ClienteID  = Cli.ClienteID
			  AND ( Cli.Clasificacion=Clas_Funcionario OR Cli.Clasificacion=Clas_Empleado)
		WHERE (Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
		  AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
		  AND Sol.FechaAutoriza = Par_Fecha);


SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET Salida_NO       := 'N';
SET Monto_Mayores   := 50000;
SET Sta_Autorizada  := 'A';
SET Sta_Desembol    := 'D';
SET Sta_Inactivo    := 'I';
SET Sta_Cancelado   := 'C';
SET Rel_Empleado    := 2;
SET Rep_EncSucurs   := 1;
SET Rep_DetSucurs   := 2;
SET Rep_Enc60Mil    := 3;
SET Rep_Det60Mil    := 4;
SET Rep_EncPerRel   := 5;
SET Rep_DetPerRel   := 6;
SET Rep_EncReestr   := 7;
SET Rep_DetReestr   := 8;

SET Acta_Sucursal   := 'S';
SET Acta_CreMayores := 'C';
SET Acta_Relaciona  := 'L';
SET Acta_Reestruc   := 'R';
SET Clas_Empleado	:= 'E';
SET Clas_Funcionario := 'O';
SET Tipo_Nuevo		:='N';

SET Tipo_Renovado	:='O';
SET Tipo_Reestruc	:='R';
SET Sta_Vigente	    :='V';
SET Sta_Vencido     :='B';



    -- SE CREA TABLA TEMPORAL  PARA GUARDAR LAS RELACIONES
		DROP TABLE IF EXISTS TMPCOMITECREDDETSUC;
		CREATE TEMPORARY TABLE TMPCOMITECREDDETSUC(
			ClienteID	BIGINT(12)
		);
		INSERT INTO TMPCOMITECREDDETSUC (ClienteID)
			SELECT Rel.ClienteID
				FROM RELACIONCLIEMPLEADO Rel
					 INNER JOIN SOLICITUDCREDITO Sol ON Rel.ClienteID = Sol.ClienteID
				WHERE  Rel.TipoRelacion = Rel_Empleado;



-- SECCION PARA ENCABEZADO DE REPORTE DE SUCURSALES
	IF(Par_TipoReporte = Rep_EncSucurs) THEN
		SET Var_NomAutori   := Cadena_Vacia;
        SET Var_Folio		:= Entero_Cero;


		OPEN CURSORCRESUCURS;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

			FETCH CURSORCRESUCURS INTO Var_UsuNombre;

		SET Var_NomAutori = CONCAT(Var_NomAutori, Var_UsuNombre, ', ');
		END LOOP;
	END;

    CLOSE CURSORCRESUCURS;

    SELECT Ins.Nombre, FecUltConsejoAdmon INTO Var_NomInstit, Var_FecConsejo
        FROM PARAMETROSSIS Par,
             INSTITUCIONES Ins
        WHERE Par.InstitucionID = Ins.InstitucionID;

        -- GENERAR FOLIO DE ACTA

        	TRUNCATE TABLE TMPACTASCOMITECRED;

    INSERT INTO  TMPACTASCOMITECRED (SolicitudCreditoID, 	ClienteID, 			NombreCliente,  ProductoCredito, 		Tasa,
									 MontoSolicitado, 		Estatus )
        SELECT Sol.SolicitudCreditoID,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          LPAD(CONVERT(Pro.ProspectoID,CHAR), 7, '0')
                      ELSE
                         LPAD(CONVERT(Cli.ClienteID,CHAR), 7, '0')
                     END AS ClienteID,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Pro.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Pro.SegundoNombre,Cadena_Vacia))
                                    ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Pro.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Pro.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Pro.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Pro.ApellidoMaterno,Cadena_Vacia))
                      ELSE
                         CONCAT(IFNULL(Cli.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Cli.SegundoNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Cli.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Cli.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
                     END AS NombreCliente,
                    Prc.Descripcion AS ProductoCredito,
                    IFNULL(FORMAT(TasaFija,2),'') AS Tasa,
                    MontoSolici AS MontoSolicitado,
                    IFNULL(Sol.Estatus,'') AS Estatus
        FROM SOLICITUDCREDITO Sol
        LEFT JOIN CLIENTES Cli    ON Sol.ClienteID  = Cli.ClienteID
        LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID AND IFNULL(Sol.ClienteID, Entero_Cero) = Entero_Cero
        INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
        INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Fir.OrganoID IN(1,2,5)
        WHERE(Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
          AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
          AND Sol.FechaAutoriza = Par_Fecha
		  AND Sol.SucursalID    = Par_SucursalID
		GROUP BY Sol.SolicitudCreditoID;



          -- CONTAR LOS REGISTROS DE LA TABLA
          SELECT COUNT(SolicitudCreditoID)
          INTO Var_Registros
          FROM TMPACTASCOMITECRED;


          -- GENERAR NUMERO DE FOLIO SI LA TABLA NO ESTA VACIA
          IF(Var_Registros!=0) THEN
			  CALL `FOLIOACTACOMITEALT`(
			Acta_Sucursal,    	Par_Fecha,      Par_SucursalID,     Salida_NO,      Var_Folio,
            Par_NumErr,			Par_ErrMen,		Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID,	Aud_Sucursal,       Aud_NumTransaccion  );
          END IF;

        -- FIN GENERAR FOLIO DE ACTA

    SELECT NombreSucurs INTO Var_NomSucurs
        FROM SUCURSALES
        WHERE SucursalID = Par_SucursalID;

    SELECT  Var_NomInstit AS NombreInstitucion,
            CONVERT(Par_Fecha, CHAR) AS Fecha,
            Var_NomSucurs AS NombreSucursal,
            FUNCIONLETRASFECHA(Var_FecConsejo) AS FechaConsejo,
            SUBSTRING(Var_NomAutori, 1, CHAR_LENGTH(Var_NomAutori) -2) AS Autorizadores,
            Var_Folio AS Folio;
END IF;

-- SECCION PARA DETALLE DE REPORTE DE SUCURSAL
IF(Par_TipoReporte = Rep_DetSucurs) THEN
	TRUNCATE TABLE TMPACTASCOMITECRED;
  INSERT INTO  TMPACTASCOMITECRED (SolicitudCreditoID, 	ClienteID, 			NombreCliente,  ProductoCredito, 		Tasa,
								   MontoSolicitado, 		Estatus )
   SELECT Sol.SolicitudCreditoID,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          LPAD(CONVERT(Pro.ProspectoID,CHAR), 7, '0')
                      ELSE
                         LPAD(CONVERT(Cli.ClienteID,CHAR), 7, '0')
                     END AS ClienteID,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Pro.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Pro.SegundoNombre,Cadena_Vacia))
                                    ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Pro.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Pro.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Pro.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Pro.ApellidoMaterno,Cadena_Vacia))
                      ELSE
                         CONCAT(IFNULL(Cli.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Cli.SegundoNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Cli.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Cli.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
                     END AS NombreCliente,
                    Prc.Descripcion AS ProductoCredito,
                    IFNULL(FORMAT(TasaFija,2),'') AS Tasa,
                    MontoSolici AS MontoSolicitado,
                    IFNULL(Sol.Estatus,'') AS Estatus
        FROM SOLICITUDCREDITO Sol
        LEFT JOIN CLIENTES Cli    ON Sol.ClienteID  = Cli.ClienteID
        LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID AND IFNULL(Sol.ClienteID, Entero_Cero) = Entero_Cero
        INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
        INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Fir.OrganoID IN(1,2,5)
        WHERE(Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
          AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
          AND Sol.FechaAutoriza = Par_Fecha
		  AND Sol.SucursalID    = Par_SucursalID
		GROUP BY  Sol.SolicitudCreditoID;


          -- DATOS QUE SE REGRESAN PARA MOSTRAR EN EL REPORTE

      SELECT SolicitudCreditoID, 	ClienteID, 			NombreCliente,  ProductoCredito, 		Tasa,
			 MontoSolicitado, 	Estatus
	  FROM   TMPACTASCOMITECRED;

TRUNCATE TABLE TMPACTASCOMITECRED;
END IF;

-- SECCION PARA ENCABEZADO DE REPORTE DE COMITE CENTRAL
	IF(Par_TipoReporte = Rep_Enc60Mil) THEN
		SET Var_NomAutori   := Cadena_Vacia;
        SET Var_Folio		:= Entero_Cero;
		OPEN CURSORCREMAYORES;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

			FETCH CURSORCREMAYORES INTO
				Var_UsuNombre;

				SET Var_NomAutori = CONCAT(Var_NomAutori, Var_UsuNombre, ', ');
			END LOOP;
		END;

    CLOSE CURSORCREMAYORES;



		SELECT Ins.Nombre, FecUltConsejoAdmon INTO Var_NomInstit, Var_FecConsejo
			FROM PARAMETROSSIS Par,
				 INSTITUCIONES Ins
			WHERE Par.InstitucionID = Ins.InstitucionID;


            -- GENERAR FOLIO PARA REPORTE
            TRUNCATE TABLE TMPACTASCOMITECRED;
			INSERT INTO  TMPACTASCOMITECRED (SolicitudCreditoID,	SucursalID, 	NombreSucurs, 		ClienteID, 			NombreCliente,
											 ProductoCredito, 		Tasa,			MontoAutorizado, 	Estatus )

	 SELECT Sol.SolicitudCreditoID, Suc.SucursalID, Suc.NombreSucurs,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          LPAD(CONVERT(Pro.ProspectoID,CHAR), 7, '0')
                      ELSE
                         LPAD(CONVERT(Cli.ClienteID,CHAR), 7, '0')
                     END AS ClienteID,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Pro.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Pro.SegundoNombre,Cadena_Vacia))
                                    ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Pro.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Pro.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Pro.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Pro.ApellidoMaterno,Cadena_Vacia))
                      ELSE
                         CONCAT(IFNULL(Cli.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Cli.SegundoNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Cli.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Cli.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
                     END AS NombreCliente,
                    Prc.Descripcion AS ProductoCredito,
                    IFNULL(FORMAT(TasaFija,2),'') AS Tasa,
                    MontoSolici AS MontoSolicitado,
                    IFNULL(Sol.Estatus,'') AS Estatus
        FROM SOLICITUDCREDITO Sol
        LEFT JOIN CLIENTES Cli    ON Sol.ClienteID  = Cli.ClienteID
        LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID AND IFNULL(Sol.ClienteID, Entero_Cero) = Entero_Cero
        INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
        INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Sol.SucursalID
        INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
			AND Fir.OrganoID IN(3,4,6)
        WHERE (Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
          AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
          AND Sol.FechaAutoriza = Par_Fecha
		  AND Sol.TipoCredito=Tipo_Nuevo
		  AND Sol.ClienteID NOT IN  ( SELECT Rel.ClienteID FROM TMPCOMITECREDDETSUC Rel)
        GROUP BY  Sol.SolicitudCreditoID
        ORDER BY  Suc.SucursalID;


		 -- CONTAR LOS REGISTROS DE LA TABLA
          SELECT COUNT(SolicitudCreditoID)
          INTO Var_Registros
          FROM TMPACTASCOMITECRED;



          -- GENERAR NUMERO DE FOLIO SI LA TABLA NO ESTA VACIA
          IF(Var_Registros!=0) THEN
			CALL `FOLIOACTACOMITEALT`(
			Acta_CreMayores,    Par_Fecha,      Par_SucursalID,     Salida_NO,      Var_Folio,
            Par_NumErr,			Par_ErrMen,		Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID,	Aud_Sucursal,       Aud_NumTransaccion  );
          END IF;

          -- FIN GENERAR FOLIO

    SELECT  Var_NomInstit AS NombreInstitucion,
            CONVERT(Par_Fecha, CHAR) AS Fecha,
            FUNCIONLETRASFECHA(Var_FecConsejo) AS FechaConsejo,
            SUBSTRING(Var_NomAutori, 1, CHAR_LENGTH(Var_NomAutori) -2) AS Autorizadores,
            Var_Folio AS Folio;
END IF;

-- SECCION PARA DETALLE DE REPORTE DE COMITE CENTRAL
	IF(Par_TipoReporte = Rep_Det60Mil) THEN

			TRUNCATE TABLE TMPACTASCOMITECRED;
			INSERT INTO  TMPACTASCOMITECRED (SolicitudCreditoID,	SucursalID, 	NombreSucurs, 		ClienteID, 			NombreCliente,
											 ProductoCredito, 		Tasa,			MontoSolicitado, 	Estatus )

	   SELECT Sol.SolicitudCreditoID, Suc.SucursalID, Suc.NombreSucurs,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          LPAD(CONVERT(Pro.ProspectoID,CHAR), 7, '0')
                      ELSE
                         LPAD(CONVERT(Cli.ClienteID,CHAR), 7, '0')
                     END AS ClienteID,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Pro.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Pro.SegundoNombre,Cadena_Vacia))
                                    ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Pro.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Pro.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Pro.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Pro.ApellidoMaterno,Cadena_Vacia))
                      ELSE
                         CONCAT(IFNULL(Cli.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Cli.SegundoNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Cli.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Cli.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
                     END AS NombreCliente,
                    Prc.Descripcion AS ProductoCredito,
                    IFNULL(FORMAT(TasaFija,2),'') AS Tasa,
                    MontoSolici AS MontoSolicitado,
                    IFNULL(Sol.Estatus,'') AS Estatus
        FROM SOLICITUDCREDITO Sol
        LEFT JOIN CLIENTES Cli    ON Sol.ClienteID  = Cli.ClienteID
        LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID AND IFNULL(Sol.ClienteID, Entero_Cero) = Entero_Cero
        INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
        INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Sol.SucursalID
        INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
			AND Fir.OrganoID IN(3,4,6)
        WHERE (Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
          AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
          AND Sol.FechaAutoriza = Par_Fecha
          AND Sol.TipoCredito=Tipo_Nuevo
		  AND Sol.ClienteID NOT IN  ( SELECT Rel.ClienteID FROM TMPCOMITECREDDETSUC Rel)
       GROUP BY Sol.SolicitudCreditoID
	   ORDER BY  Suc.SucursalID;


          -- DATOS QUE SE REGRESAN PARA MOSTRAR EN EL REPORTE

      SELECT SolicitudCreditoID,	SucursalID, 	NombreSucurs, 		ClienteID, 			NombreCliente,
			 ProductoCredito, 		Tasa,			MontoSolicitado, 	Estatus
	  FROM   TMPACTASCOMITECRED;

	TRUNCATE TABLE TMPACTASCOMITECRED;


	END IF;

-- SECCION PARA ENCABEZADO DE REPORTE DE REESTRUCTURAS Y RENOVACIONES
	IF(Par_TipoReporte = Rep_EncReestr) THEN
		SET Var_NomAutori   := Cadena_Vacia;

        SET Var_Folio		:= Entero_Cero;

		OPEN CURSORREESTRUC;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

			FETCH CURSORREESTRUC INTO
				Var_UsuNombre;

				SET Var_NomAutori := CONCAT(Var_NomAutori, Var_UsuNombre, ', ');
			END LOOP;
		END;

		CLOSE CURSORREESTRUC;

		SELECT Ins.Nombre, FecUltConsejoAdmon INTO Var_NomInstit, Var_FecConsejo
			FROM PARAMETROSSIS Par,
				 INSTITUCIONES Ins
			WHERE Par.InstitucionID = Ins.InstitucionID;


            -- GENERAR FOLIO PARA ACTA

       TRUNCATE TABLE TMPACTASCOMITECRED;
			INSERT INTO  TMPACTASCOMITECRED (SolicitudCreditoID,	SucursalID, 	NombreSucurs, 		ClienteID, 			NombreCliente,
											 ProductoCredito, 		Tasa,			MontoSolicitado,  	Estatus )
			SELECT SolicitudCreditoID, Suc.SucursalID, Suc.NombreSucurs,
				CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
							  lpad(CONVERT(Pro.ProspectoID,CHAR), 7, '0')
						  ELSE
							 lpad(CONVERT(Cli.ClienteID,CHAR), 7, '0')
						 END AS ClienteID,
				CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
							  CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia),
									(CASE WHEN IFNULL(Pro.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Pro.SegundoNombre,Cadena_Vacia))
										ELSE Cadena_Vacia END),
									(CASE WHEN IFNULL(Pro.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Pro.TercerNombre,Cadena_Vacia))
										  ELSE Cadena_Vacia END), ' ',
									IFNULL(Pro.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Pro.ApellidoMaterno,Cadena_Vacia))
						  ELSE
							 CONCAT(IFNULL(Cli.PrimerNombre,Cadena_Vacia),
									(CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Cli.SegundoNombre,Cadena_Vacia))
										  ELSE Cadena_Vacia END),
									(CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Cli.TercerNombre,Cadena_Vacia))
										  ELSE Cadena_Vacia END), ' ',
									IFNULL(Cli.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
						 END AS NombreCliente,
						Prc.Descripcion AS ProductoCredito,
						IFNULL(FORMAT(TasaFija,2),'') AS Tasa,
						MontoSolici AS MontoSolicitado,	IFNULL(Sol.Estatus,'') AS Estatus
		FROM SOLICITUDCREDITO Sol
			LEFT JOIN CLIENTES Cli    ON Sol.ClienteID  = Cli.ClienteID
           	LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID AND IFNULL(Sol.ClienteID, Entero_Cero) = Entero_Cero
			INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
			INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Sol.SucursalID
			WHERE (Sol.Estatus  = Sta_Autorizada OR Sol.Estatus  = Sta_Desembol)
          AND (Sol.TipoCredito=Tipo_Renovado OR Sol.TipoCredito=Tipo_Reestruc)
		  AND Sol.FechaAutoriza = Par_Fecha;



          -- CONTAR LOS REGISTROS DE LA TABLA
          SELECT COUNT(SolicitudCreditoID)
          INTO Var_Registros
          FROM TMPACTASCOMITECRED;

          -- GENERAR NUMERO DE FOLIO SI LA TABLA NO ESTA VACIA
          IF(Var_Registros!=0) THEN


			CALL `FOLIOACTACOMITEALT`(
			Acta_Reestruc,   	Par_Fecha,      Par_SucursalID,     Salida_NO,      Var_Folio,
            Par_NumErr,			Par_ErrMen,		Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID,	Aud_Sucursal,       Aud_NumTransaccion  );


          END IF;

            -- FIN GENERAR FOLIO ACTA

		SELECT  Var_NomInstit AS NombreInstitucion,
				CONVERT(Par_Fecha, CHAR) AS Fecha,
				FUNCIONLETRASFECHA(Var_FecConsejo) AS FechaConsejo,
				substring(Var_NomAutori, 1, CHAR_LENGTH(Var_NomAutori) -2) AS Autorizadores,
				Var_Folio AS Folio;
	END IF;


-- SECCION PARA DETALLE DE REESTRUCTURAS Y  RENOVACIONES
IF(Par_TipoReporte = Rep_DetReestr) THEN

			TRUNCATE TABLE TMPACTASCOMITECRED;
			INSERT INTO  TMPACTASCOMITECRED (SolicitudCreditoID,	SucursalID, 	NombreSucurs, 		ClienteID, 			NombreCliente,
											 ProductoCredito, 		Tasa,			MontoSolicitado,  	Estatus )
SELECT SolicitudCreditoID, Suc.SucursalID, Suc.NombreSucurs,
				CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
							  lpad(CONVERT(Pro.ProspectoID,CHAR), 7, '0')
						  ELSE
							 lpad(CONVERT(Cli.ClienteID,CHAR), 7, '0')
						 END AS ClienteID,
				CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
							  CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia),
									(CASE WHEN IFNULL(Pro.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Pro.SegundoNombre,Cadena_Vacia))
										ELSE Cadena_Vacia END),
									(CASE WHEN IFNULL(Pro.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Pro.TercerNombre,Cadena_Vacia))
										  ELSE Cadena_Vacia END), ' ',
									IFNULL(Pro.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Pro.ApellidoMaterno,Cadena_Vacia))
						  ELSE
							 CONCAT(IFNULL(Cli.PrimerNombre,Cadena_Vacia),
									(CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Cli.SegundoNombre,Cadena_Vacia))
										  ELSE Cadena_Vacia END),
									(CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Cli.TercerNombre,Cadena_Vacia))
										  ELSE Cadena_Vacia END), ' ',
									IFNULL(Cli.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
						 END AS NombreCliente,
						Prc.Descripcion AS ProductoCredito,
						IFNULL(FORMAT(TasaFija,2),'') AS Tasa,
						MontoSolici AS MontoSolicitado,	IFNULL(Sol.Estatus,'') AS Estatus
		FROM SOLICITUDCREDITO Sol
			LEFT JOIN CLIENTES Cli    ON Sol.ClienteID  = Cli.ClienteID
           	LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID AND IFNULL(Sol.ClienteID, Entero_Cero) = Entero_Cero
			INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
			INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Sol.SucursalID
			WHERE (Sol.Estatus  = Sta_Autorizada OR Sol.Estatus  = Sta_Desembol)
          AND (Sol.TipoCredito=Tipo_Renovado OR Sol.TipoCredito=Tipo_Reestruc)
		  AND Sol.FechaAutoriza = Par_Fecha;


           -- DATOS QUE SE REGRESAN PARA MOSTRAR EN EL REPORTE

           SELECT SolicitudCreditoID,	SucursalID, 	NombreSucurs, 		ClienteID, 			NombreCliente,
				  ProductoCredito, 		Tasa,			MontoSolicitado,  	Estatus
	  FROM   TMPACTASCOMITECRED;

END IF;

-- SECCION PARA ENCABEZADO DE REPORTE DE PERSONAS RELACIONADAS
IF(Par_TipoReporte = Rep_EncPerRel) THEN
    SET Var_NomAutori   := Cadena_Vacia;
    SET Var_Folio		:= Entero_Cero;
    OPEN CURSORCRERELACI;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP

        FETCH CURSORCRERELACI INTO
            Var_UsuNombre;

            SET Var_NomAutori = CONCAT(Var_NomAutori, Var_UsuNombre, ', ');
        END LOOP;
    END;

    CLOSE CURSORCRERELACI;

    -- GENERAR FOLIO DE REPORTE
    TRUNCATE TABLE TMPACTASCOMITECRED;

			 INSERT INTO  TMPACTASCOMITECRED (SolicitudCreditoID, 	SucursalID, 	NombreSucurs,		ClienteID, 		NombreCliente,
											 ProductoCredito, 		Tasa,			MontoSolicitado,  	Estatus )



   ( SELECT Sol.SolicitudCreditoID, Suc.SucursalID, Suc.NombreSucurs,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          LPAD(CONVERT(Pro.ProspectoID,CHAR), 7, '0')
                      ELSE
                         LPAD(CONVERT(Cli.ClienteID,CHAR), 7, '0')
                     END AS ClienteID,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Pro.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Pro.SegundoNombre,Cadena_Vacia))
                                    ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Pro.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Pro.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Pro.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Pro.ApellidoMaterno,Cadena_Vacia))
                      ELSE
                         CONCAT(IFNULL(Cli.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Cli.SegundoNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Cli.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Cli.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
                     END AS NombreCliente,
                    Prc.Descripcion AS ProductoCredito,
                    IFNULL(FORMAT(TasaFija,2),'') AS Tasa,
                    MontoSolici AS MontoSolicitado,
                    IFNULL(Sol.Estatus,'') AS Estatus
        FROM SOLICITUDCREDITO Sol
        LEFT JOIN CLIENTES Cli    ON Sol.ClienteID  = Cli.ClienteID
        LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID AND IFNULL(Sol.ClienteID, Entero_Cero) = Entero_Cero
        INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
        INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Sol.SucursalID
        INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Fir.OrganoID IN(3,4,6)
        WHERE (Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
          AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
          AND Sol.FechaAutoriza = Par_Fecha
          AND Sol.TipoCredito=Tipo_Nuevo
		  AND Sol.ClienteID IN  ( SELECT DISTINCT(Rel.ClienteID )
										FROM RELACIONCLIEMPLEADO Rel
										WHERE Rel.ClienteID = Sol.ClienteID
										AND Rel.TipoRelacion = Rel_Empleado ))
UNION

(SELECT Sol.SolicitudCreditoID, Suc.SucursalID, Suc.NombreSucurs,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          lpad(CONVERT(Pro.ProspectoID,CHAR), 7, '0')
                      ELSE
                         lpad(CONVERT(Cli.ClienteID,CHAR), 7, '0')
                     END AS ClienteID,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Pro.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Pro.SegundoNombre,Cadena_Vacia))
                                    ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Pro.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Pro.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Pro.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Pro.ApellidoMaterno,Cadena_Vacia))
                      ELSE
                         CONCAT(IFNULL(Cli.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Cli.SegundoNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Cli.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Cli.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
                     END AS NombreCliente,
                    Prc.Descripcion AS ProductoCredito,
                    IFNULL(FORMAT(TasaFija,2),'') AS Tasa,
                    MontoSolici AS MontoSolicitado,
                    IFNULL(Sol.Estatus,'') AS Estatus
        FROM SOLICITUDCREDITO Sol
        LEFT JOIN CLIENTES Cli    ON Sol.ClienteID  = Cli.ClienteID

        LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID AND IFNULL(Sol.ClienteID, Entero_Cero) = Entero_Cero
        INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
        INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Sol.SucursalID
        INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Fir.OrganoID IN(3,4,6)
        WHERE (Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
          AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
          AND Sol.FechaAutoriza = Par_Fecha
          AND ( Cli.Clasificacion=Clas_Funcionario OR Cli.Clasificacion=Clas_Empleado)
          AND Sol.TipoCredito=Tipo_Nuevo
           GROUP BY Sol.SolicitudCreditoID);


       -- CONTAR LOS REGISTROS DE LA TABLA
          SELECT COUNT(SolicitudCreditoID)
          INTO Var_Registros
          FROM TMPACTASCOMITECRED;

          -- GENERAR NUMERO DE FOLIO SI LA TABLA NO ESTA VACIA
          IF(Var_Registros!=0) THEN

			CALL `FOLIOACTACOMITEALT`(
			Acta_Relaciona,    Par_Fecha,      Par_SucursalID,     Salida_NO,      Var_Folio,
            Par_NumErr,			Par_ErrMen,		Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID,	Aud_Sucursal,       Aud_NumTransaccion  );
          END IF;


    -- FIN FOLIO

    SELECT Ins.Nombre, FecUltConsejoAdmon INTO Var_NomInstit, Var_FecConsejo
        FROM PARAMETROSSIS Par,
             INSTITUCIONES Ins
        WHERE Par.InstitucionID = Ins.InstitucionID;

    SELECT  Var_NomInstit AS NombreInstitucion,
            CONVERT(Par_Fecha, CHAR) AS Fecha,
            FUNCIONLETRASFECHA(Var_FecConsejo) AS FechaConsejo,
            SUBSTRING(Var_NomAutori, 1, CHAR_LENGTH(Var_NomAutori) -2) AS Autorizadores,
            Var_Folio AS Folio;
END IF;

-- SECCION PARA DETALLE DE REPORTE DE PERSONAS RELACIONADAS

IF(Par_TipoReporte = Rep_DetPerRel) THEN

			TRUNCATE TABLE TMPACTASCOMITECRED;
			 INSERT INTO  TMPACTASCOMITECRED (SolicitudCreditoID, 	SucursalID, 	NombreSucurs,		ClienteID, 		NombreCliente,
											 ProductoCredito, 		Tasa,			MontoSolicitado,  	Estatus )


        (SELECT Sol.SolicitudCreditoID, Suc.SucursalID, Suc.NombreSucurs,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          LPAD(CONVERT(Pro.ProspectoID,CHAR), 7, '0')
                      ELSE
                         LPAD(CONVERT(Cli.ClienteID,CHAR), 7, '0')
                     END AS ClienteID,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Pro.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Pro.SegundoNombre,Cadena_Vacia))
                                    ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Pro.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Pro.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Pro.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Pro.ApellidoMaterno,Cadena_Vacia))
                      ELSE
                         CONCAT(IFNULL(Cli.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Cli.SegundoNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Cli.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Cli.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
                     END AS NombreCliente,
                    Prc.Descripcion AS ProductoCredito,
                    IFNULL(FORMAT(TasaFija,2),'') AS Tasa,
                    MontoSolici AS MontoSolicitado,
                    IFNULL(Sol.Estatus,'') AS Estatus
        FROM SOLICITUDCREDITO Sol
        LEFT JOIN CLIENTES Cli    ON Sol.ClienteID  = Cli.ClienteID
        LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID AND IFNULL(Sol.ClienteID, Entero_Cero) = Entero_Cero
        INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
        INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Sol.SucursalID
        INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Fir.OrganoID IN(3,4,6)
        WHERE (Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
          AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
          AND Sol.FechaAutoriza = Par_Fecha
          AND Sol.TipoCredito=Tipo_Nuevo
		  AND Sol.ClienteID IN  ( SELECT DISTINCT(Rel.ClienteID )
										FROM RELACIONCLIEMPLEADO Rel
										WHERE Rel.ClienteID = Sol.ClienteID
										AND Rel.TipoRelacion = Rel_Empleado ))
UNION

(SELECT Sol.SolicitudCreditoID, Suc.SucursalID, Suc.NombreSucurs,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          lpad(CONVERT(Pro.ProspectoID,CHAR), 7, '0')
                      ELSE
                         lpad(CONVERT(Cli.ClienteID,CHAR), 7, '0')
                     END AS ClienteID,
            CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
                          CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Pro.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Pro.SegundoNombre,Cadena_Vacia))
                                    ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Pro.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Pro.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Pro.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Pro.ApellidoMaterno,Cadena_Vacia))
                      ELSE
                         CONCAT(IFNULL(Cli.PrimerNombre,Cadena_Vacia),
                                (CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', IFNULL(Cli.SegundoNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END),
                                (CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', IFNULL(Cli.TercerNombre,Cadena_Vacia))
                                      ELSE Cadena_Vacia END), ' ',
                                IFNULL(Cli.ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
                     END AS NombreCliente,
                    Prc.Descripcion AS ProductoCredito,
                    IFNULL(FORMAT(TasaFija,2),'') AS Tasa,
                    MontoSolici AS MontoSolicitado,
                    IFNULL(Sol.Estatus,'') AS Estatus
        FROM SOLICITUDCREDITO Sol
        LEFT JOIN CLIENTES Cli    ON Sol.ClienteID  = Cli.ClienteID

        LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID AND IFNULL(Sol.ClienteID, Entero_Cero) = Entero_Cero
        INNER JOIN PRODUCTOSCREDITO Prc ON Prc.ProducCreditoID = Sol.ProductoCreditoID
        INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Sol.SucursalID
        INNER JOIN ESQUEMAAUTFIRMA Fir ON Fir.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Fir.OrganoID IN(3,4,6)
        WHERE (Sol.Estatus = Sta_Autorizada OR Sol.Estatus = Sta_Desembol)
          AND IFNULL(Sol.Relacionado, Entero_Cero) = Entero_Cero
          AND Sol.FechaAutoriza = Par_Fecha
          AND ( Cli.Clasificacion=Clas_Funcionario OR Cli.Clasificacion=Clas_Empleado)
          AND Sol.TipoCredito=Tipo_Nuevo);

        SELECT 	SolicitudCreditoID, 	SucursalID, 	NombreSucurs,		ClienteID, 		NombreCliente,
				ProductoCredito, 		Tasa,			MontoSolicitado,  	Estatus
		FROM   TMPACTASCOMITECRED
		GROUP BY SolicitudCreditoID;


END IF;


END TerminaStore$$