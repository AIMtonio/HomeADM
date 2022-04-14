-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURAREP`;
DELIMITER $$


CREATE PROCEDURE `FACTURAREP`(
	-- Proceso que genere informacion para el Reporte de Facturas
	Par_FechaInicio			DATE,				-- Fecha de Inicio
	Par_FechaFin 			DATE,				-- Fecha de Fin
	Par_Estatus  			CHAR(1),			-- Estatus de la Factura
	Par_ProveedorID			INT(11),			-- ID del Proveedor
	Par_Sucursal			INT(11),			-- Numero de Sucursal

    Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista
	Par_OrigenDatos			VARCHAR(50),		-- Origen de Datos
	Par_TipoCaptura			INT(11),			-- Tipo de Captura 1.-MANUAL 2.-MASIVA

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATE,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
		)

TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Var_Sentencia 		VARCHAR(3000);
	DECLARE Tipo_PerMoral 		CHAR(1);
	DECLARE TodosEstatus 		CHAR(1);
	DECLARE Entero_Cero 		INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Lis_PDF				INT(11);
	DECLARE Lis_Excel			INT(11);
	DECLARE Lis_DetEst_Pag		INT(11);
	DECLARE Lis_Encabezados		INT(11);
	DECLARE Pago_SPEI			CHAR(1);
	DECLARE Pago_CHEQUE			CHAR(1);
	DECLARE Pago_TARJETA		CHAR(1);
	DECLARE Pago_BANCA			CHAR(1);
	DECLARE Pago_Desc_SPEI		VARCHAR(100);
	DECLARE Pago_Desc_CHEQUE	VARCHAR(100);
	DECLARE Pago_Desc_TARJETA	VARCHAR(100);
	DECLARE Pago_Desc_BANCA		VARCHAR(100);
	DECLARE Anticipado_SI		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE ConstanteSI			CHAR(1);
	DECLARE ConstanteNO			CHAR(1);
	DECLARE Retenido  			CHAR(1);
	DECLARE Gravado				CHAR(1);
	DECLARE RetencionIVA		VARCHAR(50);
	DECLARE RetencionISR		VARCHAR(50);

	-- Declaracion de variables
	DECLARE Var_Col				VARCHAR(5000);
	DECLARE Var_Columnas		VARCHAR(5000);
	DECLARE Var_QueryTable 		VARCHAR(500);
	DECLARE Var_SelectTable     VARCHAR(50000);

	-- Asignacion de constantes
	SET Tipo_PerMoral 			:= 'M'; 		-- Persona Moral
	SET TodosEstatus 			:= 'T';		 	-- Todos los estatus
	SET Entero_Cero 			:=	0;			-- Entero_Cero
	SET Decimal_Cero			:=  0.0;		-- Decimal Cero
	SET Cadena_Vacia			:= "";   		-- Cadena Vacia
	SET Lis_PDF					:=	1;  		-- Reporte en PDF
	SET Lis_Excel				:=	2;			-- Lista en excel de manera sumarizada
	SET Lis_DetEst_Pag			:=  3;  		-- Lista detallada con estatus pagado
	SET Lis_Encabezados			:= 	4;			-- Lista de encabezados del reporte
	SET Pago_SPEI				:= "S"; 		-- Forma de Pago con SPEI
	SET Pago_CHEQUE				:= "C"; 		-- Forma de pago con CHEQUE
	SET Pago_TARJETA			:= "T"; 		-- Forma de Pago con Tarjeta Empresarial
	SET Pago_BANCA				:= "B"; 		-- Forma de Pago con Banca Electronica
	SET Pago_Desc_SPEI			:="TRANS-";		-- Descripcion Forma de Pago con SPEI
	SET Pago_Desc_CHEQUE		:="CHEQUE-";  	-- Descripcion Forma de Pago con CHEQUE
	SET Pago_Desc_TARJETA		:="TARJETA-";  	-- Descripcion Forma de Pago con TARJETA EMPRESARIAL
	SET Pago_Desc_BANCA			:="BANCA E";  	-- Descripcion Forma de Pago con BANCA ELECTRONICA
	SET Anticipado_SI			:="S"; 			-- Pago Anticipado SI
	SET Par_proveedorID 		:= IFNULL(Par_proveedorID,Entero_Cero); 	-- Numero Proveedor
	SET Par_Sucursal    		:= IFNULL(Par_Sucursal,Entero_Cero);		-- Numero Sucursal
	SET Par_Estatus     		:= IFNULL(Par_Estatus,TodosEstatus);		-- Estatus
	SET ConstanteSI			    :="S";			-- Constante: SI
	SET ConstanteNo				:="N";			-- Constante: NO
	SET Retenido				:= 'R';			-- Importe: Retenido
	SET Gravado					:= 'G';			-- Importe: Gravado
	SET RetencionIVA			:= 'RET IVA';	-- Descripcion: Retencion IVA
	SET RetencionISR			:= 'RET ISR';	-- Descripcion: Retencion ISR
	SET Par_OrigenDatos 		:= DATABASE();
	-- Se llama SP para calcular los importes de los impuestos.
	CALL FACTURAREPIMPUESTOS(
		Par_FechaInicio,	Par_FechaFin,		Par_OrigenDatos,	Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

	IF(Par_NumLis=Lis_PDF) THEN

		-- Tabla temporal para el registro de informacion de Facturas para mostrarlo en PDF
		DROP TEMPORARY TABLE IF EXISTS TMPFACTURASPDF;
        CREATE TEMPORARY TABLE TMPFACTURASPDF (
			ProveedorID   		INT(11) 		COMMENT 'ID Proveedor',
			NombreProv        	VARCHAR(200) 	COMMENT 'Nombre Proveedor',
			CURP        		CHAR(18) 		COMMENT 'CURP',
			RFC        			CHAR(13) 		COMMENT 'RFC',
			NoFactura     		VARCHAR(50) 	COMMENT 'Numero de Factura',
			Usuario 			INT(11) 		COMMENT 'ID Usuario',
			NombreUsuario     	VARCHAR(100) 	COMMENT 'Nombre Usuario',
			Monto			    DECIMAL(14,2) 	COMMENT 'Monto',
			SaldoFactura		DECIMAL(14,2) 	COMMENT 'Saldo Factura',
			FechaEmision	 	DATE 			COMMENT 'Fecha Emision',
			Estatus	   			VARCHAR(30) 	COMMENT 'Estatus',
			FechaPrefPago		DATE 			COMMENT 'Fecha Preferencia pago',
			FechaVencim	 		DATE 			COMMENT 'Fecha Vencimiento',
			SumIVANoNo    		DECIMAL(14,2) 	COMMENT 'Suma IVA: NO',
			SumIVASiSi			DECIMAL(14,2) 	COMMENT 'Suma IVA: SI',
			SumIVASiNo			DECIMAL(14,2) 	COMMENT 'Suma IVA: SI, NO',
			RetIVA				DECIMAL(14,2) 	COMMENT 'Retencion IVA',
			RetISR  			DECIMAL(14,2) 	COMMENT 'Retencion ISR',
            PolizaID			VARCHAR(20)   	COMMENT 'Numero de Poliza relacionados con DetallePoliza, se asigna el valor al dar de alta la Factura',
            FechaCancelacion	VARCHAR(20)		COMMENT 'Fecha de cancelacion',
            MotivoCancela       VARCHAR(150)	COMMENT 'Motivo de cancelacion',
            TotalFactura		DECIMAL(14,2)	COMMENT 'Monto Total Neto a Pagar de la Factura',
            ProrrateaImp       	CHAR(2) 		COMMENT 'Campo para identificar si se prorratea impuesto',
            TipoGastoID   		INT(11) 		COMMENT 'Tipo de gasto de la partida, el tipo de gasto define la contabilizacion',
            CentroCostoID   	INT(11) 		COMMENT 'Centro de Costos');

		CREATE INDEX TMPFACTURASPDF_IDX ON TMPFACTURASPDF (ProveedorID,NoFactura);

        -- Se obtiene informacion de Facturas para mostrarlo en PDF
		SET Var_Sentencia := '';
		SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INSERT INTO  TMPFACTURASPDF( ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' SELECT  CONVERT(LPAD(Fac.ProveedorID, 11,"0"), CHAR) AS  ProveedorID,CASE WHEN');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Pro.TipoPersona="',Tipo_PerMoral ,'" THEN Pro.RazonSocial ELSE ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia)," ", IFNULL(Pro.SegundoNombre,Cadena_Vacia)," ", IFNULL(Pro.ApellidoPaterno,Cadena_Vacia)," ", IFNULL(Pro.ApellidoMaterno,Cadena_Vacia)) END ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AS NombreProv,Pro.CURP,CASE WHEN Pro.TipoPersona="',Tipo_PerMoral ,'" THEN Pro.RFCpm ELSE Pro.RFC END AS RFC,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Fac.NoFactura,Fac.Usuario,Usu.NombreCompleto AS NombreUsuario,Fac.SubTotal AS Monto,Fac.SaldoFactura, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Fac.FechaFactura AS FechaEmision, CASE WHEN Fac.Estatus ="A" THEN "PENDIENTE DE PAGO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' WHEN Fac.Estatus ="C" THEN "CANCELADA" WHEN Fac.Estatus ="P" THEN "PARCIALMENTE PAGADA"');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' WHEN Fac.Estatus ="R" THEN "EN PROC. REQUISICION"   ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' WHEN Fac.Estatus ="L" THEN "PAGADA" WHEN Fac.Estatus ="V" THEN "VENCIDA" WHEN Fac.Estatus ="I" THEN "IMPORTADA"  END AS Estatus, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' DATE(Fac.FechaProgPago) AS FechaPrefPago, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' DATE(Fac.FechaVencimient) AS FechaVencim, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' SUM(CASE WHEN det.Gravable="N" AND det.GravaCero="N" AND det.ProveedorID=Fac.ProveedorID AND det.NoFactura=Fac.NoFactura THEN det.Importe ELSE 0 END) AS SumIVANoNo, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' SUM(CASE WHEN det.Gravable="S" AND det.GravaCero="S" AND det.ProveedorID=Fac.ProveedorID AND det.NoFactura=Fac.NoFactura THEN det.Importe ELSE 0 END) AS SumIVASiSi, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' SUM(CASE WHEN det.Gravable="S" AND det.GravaCero="N" AND det.ProveedorID=Fac.ProveedorID AND det.NoFactura=Fac.NoFactura THEN det.Importe ELSE 0 END) AS SumIVASiNo, 0.00, 0.00, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' IFNULL(Fac.PolizaID, "0") AS PolizaID,
													   IFNULL(Fac.FechaCancelacion, "") AS FechaCancelacion,
													   IFNULL(Fac.MotivoCancela, "") AS MotivoCancela,
													   IFNULL(Fac.TotalFactura, "0") AS TotalFactura,
													   CASE IFNULL(Fac.ProrrateaImp, "N") WHEN "S" THEN "SI" ELSE "NO" END AS ProrrateaImpuesto,
													   IFNULL(det.TipoGastoID, "0") AS TipoGasto,
													   IFNULL(det.CentroCostoID, "0") AS CentroCosto  ');
       SET Var_Sentencia := 	CONCAT(Var_Sentencia,' FROM	FACTURAPROV Fac
													   INNER JOIN DETALLEFACTPROV det ON det.ProveedorID= Fac.ProveedorID AND det.NoFactura = Fac.NoFactura
													   INNER JOIN PROVEEDORES Pro ON Pro.ProveedorID= Fac.ProveedorID
													   INNER JOIN  USUARIOS  Usu  ON Usu.UsuarioID= Fac.Usuario
                                                       WHERE Fac.FechaFactura >=? AND Fac.FechaFactura <=?');

        IF(Par_TipoCaptura != Entero_Cero AND Par_TipoCaptura=1)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND  Fac.OrigenFactura != "FM" ');
        END IF;
        IF(Par_TipoCaptura != Entero_Cero AND Par_TipoCaptura=2)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND  Fac.OrigenFactura = "FM"');
        END IF;

		IF(Par_Estatus != TodosEstatus) THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND  Fac.Estatus="',CONVERT(Par_Estatus,CHAR),'"');
		END IF;

		IF(Par_proveedorID != Entero_Cero)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Fac.ProveedorID	=',CONVERT(Par_proveedorID,CHAR)  );
		END IF;

		IF(Par_Sucursal != Entero_Cero)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,'  AND Fac.Sucursal=',CONVERT(Par_Sucursal,CHAR));
		END IF;

		SET Var_Sentencia 	  := 	CONCAT(Var_Sentencia,' GROUP BY Fac.ProveedorID,Fac.NoFactura, Fac.PolizaID, Fac.FechaCancelacion,	Fac.MotivoCancela, Fac.TotalFactura,
															Fac.ProrrateaImp, det.TipoGastoID, 	det.CentroCostoID
															ORDER BY Fac.ProveedorID, Fac.FechaFactura, Fac.Estatus ASC);');


		SET @Sentencia		= (Var_Sentencia);
		SET @FechaInicio	= Par_FechaInicio;
		SET @FechaFin		= Par_FechaFin;
		PREPARE STFACTURAREP FROM @Sentencia;
		EXECUTE STFACTURAREP USING @FechaInicio, @FechaFin;
		DEALLOCATE PREPARE STFACTURAREP;


		-- SE CREA UNA TABLA TEMPORAL PARA LOS DE IMPORTES GRAVADOS Y RETENIDOS %
        DROP TEMPORARY TABLE IF EXISTS TMPFACTURASIMP;
        CREATE TEMPORARY TABLE TMPFACTURASIMP (
			ProveedorID   	INT(11) 		COMMENT 'ID Proveedor',
			NoFactura     	VARCHAR(50) 	COMMENT	'Numero de Factura',
			RetenIVA		DECIMAL(14,2) 	COMMENT	'Retencion IVA',
			RetenISR  		DECIMAL(14,2)) 	COMMENT	'Retencion ISR';

		CREATE INDEX TMPFACTURASIMP_IDX ON TMPFACTURASIMP (ProveedorID,NoFactura);

		SET Var_Sentencia := '';
		SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INSERT INTO  TMPFACTURASIMP( ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' SELECT  CONVERT(LPAD(Fac.ProveedorID, 11,"0"), CHAR) AS  ProveedorID, Fac.NoFactura, SUM( CASE WHEN I.DescripCorta = "',RetencionIVA,'" THEN IFNULL(D.ImporteImpuesto,0.00) ELSE 0.00 END) AS RetenIVA, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' SUM( CASE WHEN I.DescripCorta = "',RetencionISR,'" THEN IFNULL(D.ImporteImpuesto,0.00) ELSE 0.00 END) AS RetenISR ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' FROM	FACTURAPROV Fac ');
		SET Var_Sentencia :=	CONCAT(Var_Sentencia,' INNER JOIN DETALLEIMPFACT D ON Fac.ProveedorID = D.ProveedorID AND Fac.NoFactura = D.NoFactura');
		SET Var_Sentencia :=	CONCAT(Var_Sentencia,' INNER JOIN IMPUESTOS I ON I.ImpuestoID = D.ImpuestoID');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' WHERE Fac.FechaFactura >=? AND Fac.FechaFactura <=? ');

		IF(Par_Estatus != TodosEstatus) THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND  Fac.Estatus="',CONVERT(Par_Estatus,CHAR),'"');
		END IF;

		IF(Par_proveedorID != Entero_Cero)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Fac.ProveedorID	=',CONVERT(Par_proveedorID,CHAR)  );
		END IF;

		IF(Par_Sucursal != Entero_Cero)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,'  AND Fac.Sucursal=',CONVERT(Par_Sucursal,CHAR));
		END IF;

		SET Var_Sentencia 	  := 	CONCAT(Var_Sentencia,' GROUP BY Fac.ProveedorID,Fac.NoFactura  ORDER BY Fac.ProveedorID, Fac.FechaFactura, Fac.Estatus ASC);');


		SET @Sentencia		= (Var_Sentencia);
		SET @FechaInicio	= Par_FechaInicio;
		SET @FechaFin		= Par_FechaFin;
		PREPARE STFACTURAREPIMP FROM @Sentencia;
		EXECUTE STFACTURAREPIMP USING @FechaInicio, @FechaFin;
		DEALLOCATE PREPARE STFACTURAREPIMP;


		UPDATE TMPFACTURASPDF Tmp
				INNER JOIN TMPFACTURASIMP Imp ON Imp.NoFactura = Tmp.NoFactura AND Imp.ProveedorID = Tmp.ProveedorID
				SET   Tmp.RetIVA = Imp.RetenIVA;

		UPDATE TMPFACTURASPDF Tmp
				INNER JOIN TMPFACTURASIMP Imp ON Imp.NoFactura = Tmp.NoFactura AND Imp.ProveedorID = Tmp.ProveedorID
				SET   Tmp.RetISR = Imp.RetenISR;

	    -- **************************************************************************************************************
		ALTER TABLE TMPFACTURASPDF ADD COLUMN  Importe16 DECIMAL(13,2) AFTER RetISR;
		ALTER TABLE TMPFACTURASPDF ADD COLUMN  Importe0 DECIMAL(13,2) AFTER Importe16;
		ALTER TABLE TMPFACTURASPDF ADD COLUMN  ImporteExcento DECIMAL(13,2) AFTER Importe0;


		-- SE CREA UNA TABLA TEMPORAL PARA LOS DE IMPORTE AL 16 %
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE16;
		CREATE TEMPORARY TABLE TMPSUMIMPORTE16(
			ProveedorID   	INT(11)			COMMENT 'ID Proveedor',
			NoFactura     	VARCHAR(50)		COMMENT	'Numero de Factura',
			Importe			DECIMAL(14,2))	COMMENT	'Importe';

        CREATE INDEX TMPSUMIMPORTE16_IDX ON TMPSUMIMPORTE16 (ProveedorID,NoFactura);

        INSERT INTO TMPSUMIMPORTE16 (
				ProveedorID,	NoFactura,		Importe)
		SELECT  Det.ProveedorID,Det.NoFactura,IFNULL(SUM(Det.Importe),Decimal_Cero)   AS Importe
				FROM  DETALLEFACTPROV Det
				INNER JOIN TMPFACTURASPDF  Tmp ON Det.NoFactura = Tmp.NoFactura AND Det.ProveedorID = Tmp.ProveedorID
				WHERE IFNULL(Det.Gravable,ConstanteNO) = ConstanteSI AND IFNULL(Det.GravaCero,ConstanteNO) = ConstanteNO GROUP BY Det.NoFactura,Det.ProveedorID;

		-- HACEMOS EL UPDATE PARA LOS DE IMPORTE AL 16 %
		UPDATE TMPFACTURASPDF Tmp
				INNER JOIN TMPSUMIMPORTE16 Imp ON Imp.NoFactura = Tmp.NoFactura AND Imp.ProveedorID = Tmp.ProveedorID
				SET   Tmp.Importe16= Imp.Importe;

		-- SE CREA UNA TABLA TEMPORAL PARA LOS DE IMPORTE AL 0 %
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE0;
		CREATE TEMPORARY TABLE TMPSUMIMPORTE0(
			ProveedorID   	INT(11)         COMMENT 'ID Proveedor',
			NoFactura     	VARCHAR(50)		COMMENT	'Numero de Factura',
			Importe			DECIMAL(14,2))	COMMENT	'Importe';

		CREATE INDEX TMPSUMIMPORTE0_IDX ON TMPSUMIMPORTE0 (ProveedorID,NoFactura);

        INSERT INTO TMPSUMIMPORTE0 (
				ProveedorID,	NoFactura,	Importe)
		SELECT  Det.ProveedorID,Det.NoFactura,IFNULL(SUM(Det.Importe),Decimal_Cero)   AS Importe
				FROM  DETALLEFACTPROV Det
				INNER JOIN  TMPFACTURASPDF Tmp ON Det.NoFactura = Tmp.NoFactura AND Det.ProveedorID = Tmp.ProveedorID
				WHERE IFNULL(Det.Gravable,ConstanteNO) = ConstanteSI AND IFNULL(Det.GravaCero,ConstanteNO) = ConstanteSI GROUP BY Det.NoFactura,Det.ProveedorID;

		-- HACEMOS EL UPDATE PARA LOS DE IMPORTE AL 0 %
		UPDATE TMPFACTURASPDF Tmp
				INNER JOIN TMPSUMIMPORTE0 Imp ON Imp.NoFactura = Tmp.NoFactura AND Imp.ProveedorID = Tmp.ProveedorID
				SET   Tmp.Importe0 = Imp.Importe;

		-- SE CREA UNA TABLA TEMPORAL PARA LOS DE IMPORTE  EXCENTO
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTEEX;
		CREATE TEMPORARY TABLE TMPSUMIMPORTEEX(
			ProveedorID   	INT(11)        	COMMENT 'ID Proveedor',
			NoFactura     	VARCHAR(50)		COMMENT	'Numero de Factura',
			Importe			DECIMAL(14,2))	COMMENT	'Importe';

        CREATE INDEX TMPSUMIMPORTEEX_IDX ON TMPSUMIMPORTEEX (ProveedorID,NoFactura);

		INSERT INTO TMPSUMIMPORTEEX (
				ProveedorID,	NoFactura,	Importe)
		SELECT  Det.ProveedorID,Det.NoFactura,IFNULL(SUM(Det.Importe),Decimal_Cero) AS Importe
				FROM DETALLEFACTPROV Det
				INNER JOIN TMPFACTURASPDF Tmp ON Det.NoFactura = Tmp.NoFactura AND Det.ProveedorID = Tmp.ProveedorID
					WHERE IFNULL(Det.Gravable,ConstanteNO) = ConstanteNO AND IFNULL(Det.GravaCero,ConstanteNO) = ConstanteNO GROUP BY Det.NoFactura,Det.ProveedorID;

		-- HACEMOS EL UPDATE PARA LOS DE IMPORTE EXCENTO %
		UPDATE TMPFACTURASPDF Tmp
				INNER JOIN TMPSUMIMPORTEEX Imp ON Imp.NoFactura = Tmp.NoFactura AND Imp.ProveedorID = Tmp.ProveedorID
				SET   Tmp.ImporteExcento= Imp.Importe;

		UPDATE TMPFACTURASPDF Tmp SET  Tmp.Monto = (IFNULL(Tmp.Importe16,Decimal_Cero)+IFNULL(Tmp.Importe0,Decimal_Cero)+IFNULL(Tmp.ImporteExcento,Decimal_Cero));


		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE16;
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE0;
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTEEX;

		-- ********************************************************************************************************
		SELECT CONVERT(LPAD(ProveedorID, 11,"0"), CHAR) AS ProveedorID,   	NombreProv,  	CURP,			RFC,			NoFactura,
				Usuario,  		NombreUsuario,	Monto,   		SaldoFactura,	FechaEmision,
				Estatus,   		FechaPrefPago,	FechaVencim,	SumIVANoNo, 	SumIVASiSi,
				SumIVASiNo,  	RetIVA,			RetISR,
                PolizaID,		FechaCancelacion, MotivoCancela, TotalFactura,	ProrrateaImp, TipoGastoID,	CentroCostoID
			FROM TMPFACTURASPDF
			ORDER BY ProveedorID,FechaEmision, Estatus, PolizaID,
            FechaCancelacion, MotivoCancela, TotalFactura,	ProrrateaImp, TipoGastoID,	CentroCostoID ASC;


-- LISTA PARA REPORTE EXCEL
	ELSEIF(Par_NumLis=Lis_Excel) THEN
		-- Tabla temporal para el registro de informacion de Facturas para mostrarlo en Excel Sumarizado
        DROP TEMPORARY TABLE IF EXISTS TMPFACTURASEXCEL;
        CREATE TEMPORARY TABLE TMPFACTURASEXCEL (
			ProveedorID   		INT(11) 		COMMENT 'ID Proveedor',
			NombreProv       	VARCHAR(200)	COMMENT 'Nombre Proveedor',
			CURP        		CHAR(18) 		COMMENT 'CURP',
			RFC       			CHAR(13) 		COMMENT 'RFC',
			NoFactura     		VARCHAR(50)	    COMMENT 'Numero de Factura',
            Usuario 			INT(11) 		COMMENT 'ID Usuario',
			NombreUsuario     	VARCHAR(100) 	COMMENT 'Nombre Usuario',
			Monto			    DECIMAL(14,2)	COMMENT 'Monto',
			SaldoFactura		DECIMAL(14,2) 	COMMENT 'Saldo Factura',
			FechaEmision	 	DATE     		COMMENT 'Fecha Emision',
			Estatus    			VARCHAR(30)	    COMMENT 'Estatus',
			FechaPrefPago		DATE 			COMMENT 'Fecha Preferencia pago',
			FechaVencim	 		DATE   			COMMENT 'Fecha Vencimiento',
			SumIVANoNo    		DECIMAL(14,2)	COMMENT 'Suma IVA: NO',
			SumIVASiSi			DECIMAL(14,2)	COMMENT 'Suma IVA: SI',
			SumIVASiNo			DECIMAL(14,2)	COMMENT 'Suma IVA: SI, NO',
			PolizaID			VARCHAR(20)   	COMMENT 'Numero de Poliza relacionados con DetallePoliza, se asigna el valor al dar de alta la Factura',
            FechaCancelacion	VARCHAR(20)		COMMENT 'Fecha de cancelacion',
            MotivoCancela       VARCHAR(150)	COMMENT 'Motivo de cancelacion',
            TotalFactura		DECIMAL(14,2)	COMMENT 'Monto Total Neto a Pagar de la Factura',
            ProrrateaImp       	CHAR(2) 		COMMENT 'Campo para identificar si se prorratea impuesto',
            TipoGastoID   		INT(11) 		COMMENT 'Tipo de gasto de la partida, el tipo de gasto define la contabilizacion',
            CentroCostoID   	INT(11) 		COMMENT 'Centro de Costos'
            );

		CREATE INDEX TMPFACTURASEXCEL_IDX ON TMPFACTURASEXCEL (ProveedorID,NoFactura);


		SET Var_Sentencia := '';
		SET Var_Sentencia :=    CONCAT(Var_Sentencia,' INSERT INTO  TMPFACTURASEXCEL( ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' SELECT  CONVERT(LPAD(Fac.ProveedorID, 11,"0"), CHAR) AS  ProveedorID,CASE WHEN');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Pro.TipoPersona="',Tipo_PerMoral ,'" THEN Pro.RazonSocial ELSE ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' CONCAT(Pro.PrimerNombre ," ", Pro.SegundoNombre," ", Pro.ApellidoPaterno," ", Pro.ApellidoMaterno) END ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AS NombreProv,IFNULL(Pro.CURP,"") AS CURP,CASE WHEN Pro.TipoPersona="',Tipo_PerMoral ,'" THEN Pro.RFCpm ELSE Pro.RFC END AS RFC,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Fac.NoFactura,Fac.Usuario,Usu.NombreCompleto AS NombreUsuario,Fac.SubTotal AS Monto,Fac.SaldoFactura, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Fac.FechaFactura AS FechaEmision, CASE WHEN Fac.Estatus ="A" THEN "PENDIENTE DE PAGO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' WHEN Fac.Estatus ="C" THEN "CANCELADA" when Fac.Estatus ="P" THEN "PARCIALMENTE PAGADA"');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' WHEN Fac.Estatus ="R" THEN "EN PROC. REQUISICION"   ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' WHEN Fac.Estatus ="L" THEN "PAGADA" WHEN Fac.Estatus ="V" THEN "VENCIDA" WHEN Fac.Estatus ="I" THEN "IMPORTADA"  END AS Estatus, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' DATE(Fac.FechaProgPago) AS FechaPrefPago, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' DATE(Fac.FechaVencimient) AS FechaVencim, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' SUM(CASE WHEN det.Gravable="N" AND det.GravaCero="N" AND det.ProveedorID=Fac.ProveedorID AND det.NoFactura=Fac.NoFactura THEN det.Importe ELSE 0 END) AS SumIVANoNo, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' SUM(CASE WHEN det.Gravable="S" AND det.GravaCero="S" AND det.ProveedorID=Fac.ProveedorID AND det.NoFactura=Fac.NoFactura THEN det.Importe ELSE 0 END) AS SumIVASiSi, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' SUM(CASE WHEN det.Gravable="S" AND det.GravaCero="N" AND det.ProveedorID=Fac.ProveedorID AND det.NoFactura=Fac.NoFactura THEN det.Importe ELSE 0 END) AS SumIVASiNo, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' IFNULL(Fac.PolizaID, "0") AS PolizaID,
													   IFNULL(Fac.FechaCancelacion, "") AS FechaCancelacion,
													   IFNULL(Fac.MotivoCancela, "") AS MotivoCancela,
													   IFNULL(Fac.TotalFactura, "0") AS TotalFactura,
													   CASE IFNULL(Fac.ProrrateaImp, "N") WHEN "S" THEN "SI" ELSE "NO" END AS ProrrateaImpuesto,
													   IFNULL(det.TipoGastoID, "0") AS TipoGasto,
													   IFNULL(det.CentroCostoID, "0") AS CentroCosto  ');

        SET Var_Sentencia := 	CONCAT(Var_Sentencia,' FROM	FACTURAPROV Fac
													   INNER JOIN DETALLEFACTPROV det ON det.ProveedorID= Fac.ProveedorID AND det.NoFactura = Fac.NoFactura
													   INNER JOIN PROVEEDORES Pro ON Pro.ProveedorID= Fac.ProveedorID
													   INNER JOIN  USUARIOS  Usu  ON Usu.UsuarioID= Fac.Usuario
                                                       WHERE Fac.FechaFactura >=? AND Fac.FechaFactura <=?');

		IF(Par_TipoCaptura != Entero_Cero AND Par_TipoCaptura=1)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND  Fac.OrigenFactura != "FM" ');
        END IF;
        IF(Par_TipoCaptura != Entero_Cero AND Par_TipoCaptura=2)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND  Fac.OrigenFactura = "FM"');
        END IF;

		IF(Par_Estatus != TodosEstatus) THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND  Fac.Estatus="',CONVERT(Par_Estatus,CHAR),'"');
		END IF;

		IF(Par_proveedorID != Entero_Cero)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Fac.ProveedorID	=',CONVERT(Par_proveedorID,CHAR)  );
		END IF;

		IF(Par_Sucursal != Entero_Cero)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Fac.Sucursal=',CONVERT(Par_Sucursal,CHAR));
		END IF;

		SET Var_Sentencia 	  := 	CONCAT(Var_Sentencia,' GROUP BY  Fac.ProveedorID, Pro.TipoPersona, Pro.CURP, Fac.NoFactura,
															Fac.Usuario, Usu.NombreCompleto, Fac.SubTotal, Fac.SaldoFactura,
                                                            Fac.FechaFactura, Fac.Estatus, Fac.FechaProgPago, Fac.FechaVencimient,
                                                            Fac.PolizaID, Fac.FechaCancelacion,	Fac.MotivoCancela, Fac.TotalFactura,
															Fac.ProrrateaImp, det.TipoGastoID, 	det.CentroCostoID
                                                            ORDER BY Fac.ProveedorID, Fac.FechaFactura, Fac.Estatus ASC);');

		SET @Sentencia		= (Var_Sentencia);
		SET @FechaInicio	= Par_FechaInicio;
		SET @FechaFin		= Par_FechaFin;
		PREPARE STFACTURAREPE FROM @Sentencia;
		EXECUTE STFACTURAREPE USING @FechaInicio, @FechaFin;
		DEALLOCATE PREPARE STFACTURAREPE;



	-- **************************************************************************************************************+
		ALTER TABLE TMPFACTURASEXCEL ADD COLUMN  Importe16 DECIMAL(13,2) AFTER SumIVASiNo;
		ALTER TABLE TMPFACTURASEXCEL ADD COLUMN  Importe0 DECIMAL(13,2) AFTER Importe16;
		ALTER TABLE TMPFACTURASEXCEL ADD COLUMN  ImporteExcento DECIMAL(13,2) AFTER Importe0;


		-- SE CREA UNA TABLA TEMPORAL PARA LOS DE IMPORTE AL 16 %
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE16;
        CREATE TEMPORARY TABLE TMPSUMIMPORTE16(
			ProveedorID   	INT(11)        	COMMENT 'ID Proveedor',
			NoFactura     	VARCHAR(50)		COMMENT 'Numero de Factura',
			Importe			DECIMAL(14,2))	COMMENT 'Importe';

        CREATE INDEX TMPSUMIMPORTE16_IDX ON TMPSUMIMPORTE16 (ProveedorID,NoFactura);

        INSERT INTO TMPSUMIMPORTE16 (
				ProveedorID,	NoFactura,		Importe)
		SELECT  Det.ProveedorID,Det.NoFactura,IFNULL(SUM(Det.Importe),Decimal_Cero)   AS Importe
				FROM  DETALLEFACTPROV Det
				INNER JOIN TMPFACTURASEXCEL  Tmp ON Det.NoFactura = Tmp.NoFactura AND Det.ProveedorID = Tmp.ProveedorID
				WHERE IFNULL(Det.Gravable,ConstanteNO) = ConstanteSI AND IFNULL(Det.GravaCero,ConstanteNO) = ConstanteNO GROUP BY Det.NoFactura,Det.ProveedorID;

		-- HACEMOS EL UPDATE PARA LOS DE IMPORTE AL 16 %
		UPDATE TMPFACTURASEXCEL Tmp
				INNER JOIN TMPSUMIMPORTE16 Imp ON Imp.NoFactura = Tmp.NoFactura AND Imp.ProveedorID = Tmp.ProveedorID
				SET   Tmp.Importe16 = Imp.Importe;

		-- SE CREA UNA TABLA TEMPORAL PARA LOS DE IMPORTE AL 0 %
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE0;
		CREATE TEMPORARY TABLE TMPSUMIMPORTE0(
			ProveedorID   	INT(11)        	COMMENT 'ID Proveedor',
			NoFactura     	VARCHAR(50)		COMMENT 'Numero de Factura',
			Importe			DECIMAL(14,2))	COMMENT 'Importe';

		CREATE INDEX TMPSUMIMPORTE0_IDX ON TMPSUMIMPORTE0 (ProveedorID,NoFactura);

        INSERT INTO TMPSUMIMPORTE0 (
				ProveedorID,	NoFactura,	Importe)
		SELECT  Det.ProveedorID,Det.NoFactura,IFNULL(SUM(Det.Importe),Decimal_Cero)   AS Importe
				FROM  DETALLEFACTPROV Det
				INNER JOIN  TMPFACTURASEXCEL Tmp ON Det.NoFactura = Tmp.NoFactura AND Det.ProveedorID = Tmp.ProveedorID
				WHERE IFNULL(Det.Gravable,ConstanteNO) = ConstanteSI AND IFNULL(Det.GravaCero,ConstanteNO) = ConstanteSI GROUP BY Det.NoFactura,Det.ProveedorID;

		-- HACEMOS EL UPDATE PARA LOS DE IMPORTE AL 0 %
		UPDATE TMPFACTURASEXCEL Tmp
				INNER JOIN TMPSUMIMPORTE0 Imp ON Imp.NoFactura = Tmp.NoFactura AND Imp.ProveedorID = Tmp.ProveedorID
				SET   Tmp.Importe0 = Imp.Importe;

		-- SE CREA UNA TABLA TEMPORAL PARA LOS DE IMPORTE  EXCENTO
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTEEX;
		CREATE TEMPORARY TABLE TMPSUMIMPORTEEX(
			ProveedorID   	INT(11)        	COMMENT 'ID Proveedor',
			NoFactura     	VARCHAR(50)		COMMENT 'Numero de Factura',
			Importe			DECIMAL(14,2))	COMMENT 'Importe';

        CREATE INDEX TMPSUMIMPORTEEX_IDX ON TMPSUMIMPORTEEX (ProveedorID,NoFactura);

		INSERT INTO TMPSUMIMPORTEEX (
				ProveedorID,	NoFactura,	Importe)
		SELECT  Det.ProveedorID,Det.NoFactura,IFNULL(SUM(Det.Importe),Decimal_Cero) AS Importe
				FROM DETALLEFACTPROV Det
				INNER JOIN TMPFACTURASEXCEL Tmp ON Det.NoFactura = Tmp.NoFactura AND Det.ProveedorID = Tmp.ProveedorID
					WHERE IFNULL(Det.Gravable,ConstanteNO) = ConstanteNO AND IFNULL(Det.GravaCero,ConstanteNO) = ConstanteNO GROUP BY Det.NoFactura,Det.ProveedorID;

		-- HACEMOS EL UPDATE PARA LOS DE IMPORTE EXCENTO %
		UPDATE TMPFACTURASEXCEL Tmp
				INNER JOIN TMPSUMIMPORTEEX Imp ON Imp.NoFactura = Tmp.NoFactura AND Imp.ProveedorID = Tmp.ProveedorID
				SET   Tmp.ImporteExcento = Imp.Importe;

		UPDATE TMPFACTURASEXCEL Tmp SET  Tmp.Monto = (IFNULL(Tmp.Importe16,Decimal_Cero)+IFNULL(Tmp.Importe0,Decimal_Cero)+IFNULL(Tmp.ImporteExcento,Decimal_Cero));


		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE16;
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE0;
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTEEX;


	    -- ********************************************************************************************************

		SET Var_Col :=	(SELECT GROUP_CONCAT(COLUMN_NAME)
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'TMPIMPORTEIMPUESTOS' AND table_schema = Par_OrigenDatos 	AND COLUMN_NAME !='NoFactura'
																				AND COLUMN_NAME !='ProveedorID'
																				AND COLUMN_NAME !='ImpuestoID');

		SET Var_QueryTable 		:= Var_Col;
		SET Var_QueryTable 		:= CONCAT('SUM(TM.',REPLACE (Var_Col , ',',"),SUM(TM.") , '),');


		 DROP TABLE IF EXISTS FINALEXCELSUM;
		 SET Var_SelectTable     := CONCAT(" CREATE TABLE FINALEXCELSUM(SELECT Tmp.ProveedorID, Tmp.NombreProv,Tmp.CURP,Tmp.RFC,
												Tmp.NoFactura,Tmp.NombreUsuario AS Usuario,Tmp.CentroCostoID AS CentroCostos, Tmp.TipoGastoID AS TipoGastos,
												Tmp.ProrrateaImp AS ProrrateaImpuestos, Tmp.PolizaID AS Poliza, Tmp.TotalFactura, Tmp.Monto AS Subtotal,Tmp.SumIVASiNo AS Tasa16,
                                                Tmp.SumIVASiSi as Tasa0,Tmp.SumIVANoNo AS Excento,",Var_QueryTable,"Tmp.SaldoFactura,
                                                Tmp.FechaEmision AS FechaRegistro,Tmp.FechaVencim AS FechaVencimiento,
                                                Tmp.FechaPrefPago AS FechaEfectivaDePago,Tmp.Estatus, Tmp.FechaCancelacion, Tmp.MotivoCancela
											FROM TMPFACTURASEXCEL Tmp
                                            LEFT JOIN TMPIMPORTEIMPUESTOS TM ON TM.NoFactura=Tmp.NoFactura AND TM.ProveedorID=Tmp.ProveedorID
                                            GROUP BY Tmp.ProveedorID, Tmp.NombreProv, Tmp.CURP, Tmp.RFC, Tmp.NoFactura,
                                            Tmp.NombreUsuario, Tmp.Monto, Tmp.SumIVASiNo, Tmp.SumIVASiSi, Tmp.SumIVANoNo,Tmp.SaldoFactura, Tmp.FechaEmision,
                                            Tmp.FechaVencim, Tmp.FechaPrefPago, Tmp.Estatus,
                                            Tmp.FechaCancelacion,	Tmp.MotivoCancela,	Tmp.TotalFactura, Tmp.ProrrateaImp,
                                            Tmp.TipoGastoID, Tmp.CentroCostoID, Tmp.PolizaID
                                            ORDER BY Tmp.ProveedorID,	Tmp.FechaEmision, Tmp.Estatus, Tmp.PolizaID,
											Tmp.FechaCancelacion, Tmp.MotivoCancela, Tmp.TotalFactura,	Tmp.ProrrateaImp, Tmp.TipoGastoID,	Tmp.CentroCostoID ASC);");

		SET @Sentencia  = (Var_SelectTable);
		PREPARE SelectTable FROM @Sentencia;
		EXECUTE  SelectTable;
		DEALLOCATE PREPARE SelectTable;

		SELECT * FROM FINALEXCELSUM;

	END IF;

	IF Lis_DetEst_Pag=Par_NumLis THEN
			-- Tabla temporal para el registro de informacion de requisicion e dispersiones de Facturas
			DROP TEMPORARY TABLE IF EXISTS TMPFACTURAREP1;
			CREATE TEMPORARY TABLE TMPFACTURAREP1(
				TipoDeposito	CHAR(1)			COMMENT 'Tipo Deposito',
                CuentaDestino   VARCHAR(18)		COMMENT 'Cuenta Destino',
                ProveedorID		INT(11)			COMMENT 'ID Proveedor',
                NoFactura		VARCHAR(50))	COMMENT 'Numero Factura';

			CREATE INDEX TMPFACTURAREP1_IDX ON TMPFACTURAREP1 (ProveedorID,NoFactura);

            INSERT INTO TMPFACTURAREP1 (
					TipoDeposito,	 CuentaDestino,		ProveedorID,	NoFactura)
			SELECT  MAX(REQ.TipoDeposito) AS TipoDeposito, MAX(Dis.CuentaDestino) AS CuentaDestino, F.ProveedorID, F.NoFactura
			FROM  FACTURAPROV F
			LEFT JOIN REQGASTOSUCURMOV REQ ON REQ.NoFactura = F.NoFactura AND REQ.ProveedorID = F.ProveedorID
			LEFT JOIN DISPERSIONMOV Dis ON Dis.DispersionID = REQ.ClaveDispMov AND Dis.ProveedorID = REQ.ProveedorID
			WHERE  F.FechaFactura >= Par_FechaInicio AND F.FechaFactura <= Par_FechaFin
			GROUP BY F.ProveedorID,F.NoFactura;

            -- Tabla temporal para el registro de informacion de Facturas para mostrarlo en Excel Detallado
            DROP TEMPORARY TABLE IF EXISTS TMPFACTEXCELDET;
            CREATE TEMPORARY TABLE TMPFACTEXCELDET (
				ProveedorID			INT(11)			COMMENT 'ID Proveedor',
                RazonSocial			VARCHAR(150)	COMMENT 'Razon Social',
                NoFactura			VARCHAR(50)		COMMENT 'Numero de Factura',
                NombreUsuario		VARCHAR(100)    COMMENT 'Nombre Usuario',
                TipoProveedorID		INT(12)		    COMMENT 'ID Tipo Proveedor',
                Descripcion			VARCHAR(200)	COMMENT 'Descripcion Tipo Proveedor',
                RFC					CHAR(13)		COMMENT 'RFC',
                CURP				CHAR(18)		COMMENT 'CURP',
                FechaFactura		DATE			COMMENT 'Fecha Factura',
                SubTotal			DECIMAL(14,2)	COMMENT 'Total Gravable',
                TotalFactura		DECIMAL(14,2)	COMMENT 'Total Factura',
                TipoPago			VARCHAR(100)	COMMENT 'Tipo Pago Proveedor',
                TipoDispersion      VARCHAR(100)	COMMENT 'Tipo de Dispersion',
                SaldoFactura		DECIMAL(14,2))	COMMENT 'Saldo Factura';

            CREATE INDEX TMPFACTEXCELDET_IDX ON TMPFACTEXCELDET (ProveedorID,NoFactura);

			SET Var_Sentencia := "";
			SET Var_Sentencia := CONCAT(Var_Sentencia,'  INSERT INTO TMPFACTEXCELDET ( ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' SELECT DISTINCT P.ProveedorID, ',
				' CASE WHEN MAX(P.TipoPersona)="',Tipo_PerMoral ,'" THEN P.RazonSocial ',
					  'ELSE  CONCAT(P.PrimerNombre ," ", P.SegundoNombre," ", P.ApellidoPaterno," ", P.ApellidoMaterno) END  AS RazonSocial,',
				' F.NoFactura,MAX(Usu.NombreCompleto) AS NombreUsuario,MAX(Tip.TipoProveedorID) AS TipoProveedorID,MAX(Tip.Descripcion) AS Descripcion,',
				' CASE MAX(P.TipoPersona) WHEN "',Tipo_PerMoral ,'" THEN P.RFCpm ELSE P.RFC END AS RFC,',
				' IFNULL(MAX(P.CURP),"")AS CURP,MAX(F.FechaFactura) AS FechaFactura,MAX(F.TotalGravable) AS SubTotal,MAX(F.TotalFactura) AS TotalFactura,',
				' CASE MAX(F.PagoAnticipado) WHEN "',Anticipado_SI ,'" THEN TP.Descripcion	 ELSE "',Cadena_Vacia ,'" END AS TipoPago,',
				' CASE MAX(F.PagoAnticipado) WHEN "',Anticipado_SI ,'" THEN "',Cadena_Vacia ,'" ELSE (CASE MAX(REQ.TipoDeposito)',
				 		' WHEN "',Pago_CHEQUE ,'" THEN CONCAT("',Pago_Desc_CHEQUE ,'",MAX(REQ.CuentaDestino)) ',
						'  WHEN "',Pago_SPEI ,'" THEN CONCAT("',Pago_Desc_SPEI ,'",MAX(REQ.CuentaDestino))',
						'  WHEN "',Pago_BANCA ,'" THEN "',Pago_Desc_BANCA ,'"',
						'  WHEN "',Pago_TARJETA ,'" THEN CONCAT("',Pago_Desc_TARJETA ,'",MAX(REQ.CuentaDestino)) END )END AS TipoDispersion,	',
				' MAX(F.SaldoFactura) AS SaldoFactura',
					' FROM FACTURAPROV F  ',
					' INNER JOIN PROVEEDORES P ON P.ProveedorID=F.ProveedorID',
					' INNER JOIN TIPOPROVEEDORES Tip ON  Tip.TipoProveedorID=P.TipoProveedor',
					' INNER JOIN USUARIOS Usu ON Usu.UsuarioID=F.Usuario ',
					' LEFT  JOIN TIPOPAGOPROV TP ON TP.TipoPagoProvID= F.TipoPagoAnt',
					' LEFT  JOIN TMPFACTURAREP1 REQ ON REQ.NoFactura=F.NoFactura AND REQ.ProveedorID=F.ProveedorID',
					' WHERE  F.FechaFactura >=?',
					' AND F.FechaFactura <=?');
				IF(Par_Estatus != TodosEstatus)THEN
					SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND F.Estatus="',CONVERT(Par_Estatus,CHAR),'"');
				END IF;
				IF(Par_proveedorID != Entero_Cero)THEN
					SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND F.ProveedorID =',CONVERT(Par_proveedorID,CHAR));
				END IF;

				IF(Par_Sucursal != Entero_Cero)THEN
					SET Var_Sentencia := 	CONCAT(Var_Sentencia,'  AND F.Sucursal=',CONVERT(Par_Sucursal,CHAR));
				END IF;
					SET Var_Sentencia := CONCAT(Var_Sentencia,' GROUP BY F.ProveedorID,F.NoFactura ); ');


		SET @Sentencia		= (Var_Sentencia);
		SET @FechaInicio	= Par_FechaInicio;
		SET @FechaFin		= Par_FechaFin;
		PREPARE STFACTURAREP FROM @Sentencia;
		EXECUTE STFACTURAREP USING @FechaInicio, @FechaFin;
		DEALLOCATE PREPARE STFACTURAREP;

		ALTER TABLE TMPFACTEXCELDET ADD COLUMN  DescripcionCompra VARCHAR(200) AFTER SaldoFactura;
		ALTER TABLE TMPFACTEXCELDET ADD COLUMN  Importe16 DECIMAL(13,2) AFTER DescripcionCompra;
		ALTER TABLE TMPFACTEXCELDET ADD COLUMN  Importe0 DECIMAL(13,2) AFTER Importe16;
		ALTER TABLE TMPFACTEXCELDET ADD COLUMN  ImporteExcento DECIMAL(13,2) AFTER Importe0;

		-- SE CREA UNA TABLA TEMPORAL PARA LOS DE IMPORTE AL 16 %
        DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE16;
        CREATE TEMPORARY TABLE TMPSUMIMPORTE16(
			ProveedorID   	INT(11)        	COMMENT 'ID Proveedor',
			NoFactura     	VARCHAR(50)		COMMENT 'Numero de Factura',
			Importe			DECIMAL(14,2)	COMMENT 'Importe',
            Descripcion		VARCHAR(100))   COMMENT 'Descripcion de Tipo de Gasto';

        CREATE INDEX TMPSUMIMPORTE16_IDX ON TMPSUMIMPORTE16 (ProveedorID,NoFactura);

        INSERT INTO TMPSUMIMPORTE16 (
				ProveedorID,	NoFactura,		Importe,	Descripcion)
		SELECT  Det.ProveedorID,Det.NoFactura,IFNULL(SUM(Det.Importe),Decimal_Cero)   AS Importe ,Tes.Descripcion
				FROM  DETALLEFACTPROV Det
				INNER JOIN TMPFACTEXCELDET  Tmp ON Det.NoFactura = Tmp.NoFactura AND Det.ProveedorID = Tmp.ProveedorID
				INNER JOIN TESOCATTIPGAS Tes ON Tes.TipoGastoID = Det.TipoGastoID
				WHERE IFNULL(Det.Gravable,ConstanteNO) = ConstanteSI AND IFNULL(Det.GravaCero,ConstanteNO) = ConstanteNO GROUP BY Det.NoFactura,Det.ProveedorID,Tes.Descripcion;

		-- HACEMOS EL UPDATE PARA LOS DE IMPORTE AL 16 %
		UPDATE TMPFACTEXCELDET Tmp
				INNER JOIN TMPSUMIMPORTE16 Imp ON Imp.NoFactura = Tmp.NoFactura AND Imp.ProveedorID = Tmp.ProveedorID
				SET   Tmp.Importe16 = Imp.Importe;

		UPDATE TMPFACTEXCELDET Tmp
				INNER JOIN DETALLEFACTPROV Det ON Det.NoFactura = Tmp.NoFactura AND Det.ProveedorID = Tmp.ProveedorID
				INNER JOIN TESOCATTIPGAS Tes ON Tes.TipoGastoID = Det.TipoGastoID
				SET   Tmp.DescripcionCompra = Tes.Descripcion;

		-- SE CREA UNA TABLA TEMPORAL PARA LOS DE IMPORTE AL 0 %
        DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE0;
		CREATE TEMPORARY TABLE TMPSUMIMPORTE0(
			ProveedorID   	INT(11)        	COMMENT 'ID Proveedor',
			NoFactura     	VARCHAR(50)		COMMENT 'Numero de Factura',
			Importe			DECIMAL(14,2))	COMMENT 'Importe';

		CREATE INDEX TMPSUMIMPORTE0_IDX ON TMPSUMIMPORTE0 (ProveedorID,NoFactura);

        INSERT INTO TMPSUMIMPORTE0 (
				ProveedorID,	NoFactura,	Importe)
		SELECT  Det.ProveedorID,Det.NoFactura,IFNULL(SUM(Det.Importe),Decimal_Cero)   AS Importe
				FROM  DETALLEFACTPROV Det
				INNER JOIN  TMPFACTEXCELDET Tmp ON Det.NoFactura = Tmp.NoFactura AND Det.ProveedorID = Tmp.ProveedorID
				WHERE IFNULL(Det.Gravable,ConstanteNO) = ConstanteSI AND IFNULL(Det.GravaCero,ConstanteNO) = ConstanteSI GROUP BY Det.NoFactura,Det.ProveedorID;

		-- HACEMOS EL UPDATE PARA LOS DE IMPORTE AL 0 %
		UPDATE TMPFACTEXCELDET Tmp
				INNER JOIN TMPSUMIMPORTE0 Imp ON Imp.NoFactura = Tmp.NoFactura AND Imp.ProveedorID = Tmp.ProveedorID
				SET   Tmp.Importe0 = Imp.Importe;

		-- SE CREA UNA TABLA TEMPORAL PARA LOS DE IMPORTE  EXCENTO
        DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTEEX;
		CREATE TEMPORARY TABLE TMPSUMIMPORTEEX(
			ProveedorID   	INT(11)        	COMMENT 'ID Proveedor',
			NoFactura     	VARCHAR(50)		COMMENT 'Numero de Factura',
			Importe			DECIMAL(14,2))	COMMENT 'Importe';

        CREATE INDEX TMPSUMIMPORTEEX_IDX ON TMPSUMIMPORTEEX (ProveedorID,NoFactura);

		INSERT INTO TMPSUMIMPORTEEX (
				ProveedorID,	NoFactura,	Importe)
		SELECT  Det.ProveedorID,Det.NoFactura,IFNULL(SUM(Det.Importe),Decimal_Cero) AS Importe
				FROM DETALLEFACTPROV Det
				INNER JOIN TMPFACTEXCELDET Tmp ON Det.NoFactura = Tmp.NoFactura AND Det.ProveedorID = Tmp.ProveedorID
					WHERE IFNULL(Det.Gravable,ConstanteNO) = ConstanteNO AND IFNULL(Det.GravaCero,ConstanteNO) = ConstanteNO GROUP BY Det.NoFactura,Det.ProveedorID;

		-- HACEMOS EL UPDATE PARA LOS DE IMPORTE EXCENTO %
		UPDATE TMPFACTEXCELDET Tmp
				INNER JOIN TMPSUMIMPORTEEX Imp ON Imp.NoFactura = Tmp.NoFactura AND Imp.ProveedorID = Tmp.ProveedorID
				SET   Tmp.ImporteExcento = Imp.Importe;

		UPDATE TMPFACTEXCELDET Tmp SET  Tmp.SubTotal = (IFNULL(Tmp.Importe16,Decimal_Cero)+IFNULL(Tmp.Importe0,Decimal_Cero)+IFNULL(Tmp.ImporteExcento,Decimal_Cero));


		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE16;
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTE0;
		DROP TEMPORARY TABLE IF EXISTS TMPSUMIMPORTEEX;

	   -- ***********************************************************************************************************************************
		SET Var_Col :=	(SELECT GROUP_CONCAT(COLUMN_NAME)
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'TMPIMPORTEIMPUESTOS' AND table_schema = Par_OrigenDatos	AND COLUMN_NAME !='NoFactura'
																				AND COLUMN_NAME !='ProveedorID'
																				AND COLUMN_NAME !='ImpuestoID');

		SET Var_QueryTable 		:= Var_Col;
		SET Var_QueryTable 		:= CONCAT('SUM(TM.',REPLACE (Var_Col , ',',"),SUM(TM.") , '),');

		 DROP TABLE IF EXISTS FINALEXCELSUM;
		 SET Var_SelectTable     := CONCAT(" CREATE TABLE FINALEXCELSUM(
		 SELECT Tmp.ProveedorID AS NumeroProveedor, Tmp.RazonSocial AS NombreProveedor,Tmp.NoFactura,Tmp.NombreUsuario AS UsuarioRegistroFactura,
		 Tmp.TipoProveedorID AS TipoProveedor,Tmp.Descripcion AS DescripcionTipoProveedor,Tmp.RFC,Tmp.CURP,Tmp.FechaFactura,Tmp.SubTotal AS Subtotal,
		 Tmp.Importe16,Tmp.Importe0,Tmp.ImporteExcento,",Var_QueryTable,"Tmp.TotalFactura,Tmp.SaldoFactura,Tmp.TipoPago,Tmp.TipoDispersion,Tmp.DescripcionCompra
		 FROM TMPFACTEXCELDET Tmp LEFT JOIN TMPIMPORTEIMPUESTOS TM ON TM.NoFactura=Tmp.NoFactura AND TM.ProveedorID=Tmp.ProveedorID
         GROUP BY Tmp.ProveedorID, Tmp.RazonSocial, Tmp.NoFactura, Tmp.NombreUsuario, Tmp.TipoProveedorID, Tmp.Descripcion, Tmp.RFC,
         Tmp.CURP, Tmp.FechaFactura, Tmp.SubTotal, Tmp.Importe16, Tmp.Importe0, Tmp.ImporteExcento,Tmp.TotalFactura,
         Tmp.SaldoFactura, Tmp.TipoPago, Tmp.TipoDispersion, Tmp.DescripcionCompra);");

		SET @Sentencia  = (Var_SelectTable);
		PREPARE SelectTable FROM @Sentencia;
		EXECUTE  SelectTable;
		DEALLOCATE PREPARE SelectTable;

		SELECT * FROM FINALEXCELSUM;


	END IF;

	IF(Par_NumLis =	Lis_Encabezados) THEN
		SET Var_Columnas :=	(SELECT GROUP_CONCAT(COLUMN_NAME)
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_NAME = 'FINALEXCELSUM' AND table_schema = Par_OrigenDatos);

		SELECT Var_Columnas AS Columnas;
	END IF;

END TerminaStore$$
