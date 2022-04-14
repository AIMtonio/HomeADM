-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARCHIVODISPERSIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVODISPERSIONPRO`;
DELIMITER $$

CREATE PROCEDURE `ARCHIVODISPERSIONPRO`(
# ======================================================
# -------SP PARA EXPORTAR ARCHIVOS DE DISPERSION--------
# ======================================================
	Par_DispersionID     	INT(11),			-- FOLIO DE DISPERSION
	Par_InstitucionID	 	INT(11),			-- INSTITUCION
	Par_TipoArchivo		 	VARCHAR(2),			-- TIPO DE ARCHIVO OP.-ORDEN DE PAGO, TS.-TRANSFERENCIA SANTANDER, OT.-OTRAS TRANSFERENCIAS A TRAVES DE SANTANDER
	Par_NombreArchivo	 	VARCHAR(200),		-- NOMBRE DEL ARCHIVO
	Par_NumReporte       	TINYINT UNSIGNED,	-- NUMERO DE REPORTE

	Par_EmpresaID			INT(11),			-- AUDITORIA
	Aud_Usuario				INT(11),			-- AUDITORIA
	Aud_FechaActual			DATETIME,			-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),		-- AUDITORIA
	Aud_Sucursal			INT(11),			-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)			-- AUDITORIA
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Par_NumErr 			INT(11);		-- Numero de Error
	DECLARE Par_ErrMen 			VARCHAR(400);	-- Mensaje de Error
	DECLARE Var_MonedaBaseID	INT(11);		-- Moneda Base
	DECLARE Var_Exporta 		INT(11);		-- Variable Exporta
	DECLARE Var_Autoriza 		INT(11);		-- Variable Autoriza
	DECLARE Var_SiEnvia 		CHAR(1);		-- Variable Si Envia
	DECLARE Var_iva				DECIMAL(12,4);	-- IVA

	-- Declaracion de Constantes
	DECLARE Entero_Cero  		INT(11);		-- Entero cero
	DECLARE Cadena_Vacia    	CHAR(1);		-- Cadena Vacia
	DECLARE Fecha_Vacia    		DATE;			-- Cadena Vacia
	DECLARE SalidaNO        	CHAR(1);		-- Salida NO
	DECLARE Est_Autoriz			CHAR(1); 		-- Estatus Autorizado
	DECLARE ExportaBancomer		INT(11);		-- Exporta Bancomer
	DECLARE Act_Exportada		INT(11);		-- Estatus Exportada
	DECLARE MonedaPesos			INT(11);		-- Moneda Pesos
	DECLARE MonedaDolares		INT(11);		-- Moneda Dolares
	DECLARE MonedaEuros			INT(11);		-- Moneda Euros

	DECLARE ExportaSantander	INT(11);		-- Exporta Santander
	DECLARE Con_CodigoTranSanta	VARCHAR(5);		-- Codigo de Layaut Sanatnder
	DECLARE Con_CodigoTranOtros	VARCHAR(5);		-- Codigo de Layaut de transferencia Otros bancos
	DECLARE	EspacioBlanco		VARCHAR(1);		-- Espacio en Blanco
	DECLARE TipoTransOtros		VARCHAR(2);		-- Tipo de Tranferencia a Traves de Santander
	DECLARE TipoTransSanta		VARCHAR(2);		-- Tipo de Transferencia de Otros a Traves de Santander
	DECLARE TipoOrdenPago		VARCHAR(2);		-- Tipo de orden de Pago
	DECLARE SucursalCtaAbo		INT(11);		-- Número de sucursal de la cuenta de abono
	DECLARE NumPlazaBanxico		INT(11);		-- Número de la plaza Banxico de la cuenta
	DECLARE FormaPagoTrans		INT(11);		-- Forma de pago de Transferencia
	DECLARE InstitucionSan		INT(11);		-- Institucion Santander
	DECLARE Var_FechaSistema	DATE;			-- Fecha del Sistema
	DECLARE Var_ID				INT(11);		-- ID consecutivo
	DECLARE Var_IDTmp			INT(11);
	DECLARE Var_Aux1			INT(11);
	DECLARE Var_ClaveDispMov	INT(11);
	DECLARE Var_DispersionID	INT(11);
	DECLARE ACT_Enviada			INT(11);
	DECLARE Var_Efectivo		CHAR(1);
	DECLARE Var_OrdendePago		INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero  			:= 0;
	SET Cadena_Vacia    		:= '';
	SET Fecha_Vacia    			:= '1900-01-01';
	SET SalidaNO        		:= 'N';
	SET Est_Autoriz 			:= 'A';
	SET Var_Exporta				:= 2;
	SET Var_Autoriza			:= 3;
	SET ExportaBancomer			:= 4;
	SET ExportaSantander		:= 5;
	SET Var_SiEnvia				:= 'S';
	SET Var_iva					:= 0.0000;
	SET Act_Exportada			:= 2;
	SET MonedaPesos				:= 1;
	SET MonedaDolares			:= 2;
	SET MonedaEuros				:= 3;
	SET Con_CodigoTranSanta		:= 'LTX07';
	SET Con_CodigoTranOtros		:= 'LTX05';
	SET EspacioBlanco			:= ' ';
	SET TipoTransOtros			:= 'OT';
	SET TipoTransSanta			:= 'TS';
	SET TipoOrdenPago			:= 'OP';
	SET SucursalCtaAbo			:= 3954;
	SET NumPlazaBanxico			:= 1001;
	SET FormaPagoTrans			:= 6;
	SET InstitucionSan			:= 28;
	SET Var_ID					:= 0;
	SET ACT_Enviada				:= 1;
	SET Var_Efectivo			:= 'E';
	SET Var_OrdendePago			:= 5;

	SELECT 	 MonedaBaseID, FechaSistema
		INTO Var_MonedaBaseID, Var_FechaSistema
		FROM PARAMETROSSIS
		WHERE EmpresaID = Par_EmpresaID;

	SET Var_MonedaBaseID	:= IFNULL(Var_MonedaBaseID,Entero_Cero);
	SET Var_FechaSistema	:= IFNULL(Var_FechaSistema,Cadena_Vacia);

	IF(Par_NumReporte = Var_Exporta) THEN
		SELECT	ClaveDispMov,	DispersionID,	CuentaCargo,	Descripcion,		Referencia,
				TipoMovDIspID,	Monto,			CuentaDestino,	Identificacion,		Estatus,
				NombreBenefi,	DATE_FORMAT(FechaEnvio, '%Y-%m-%d')AS FechaEnvio,	Var_iva
			FROM DISPERSIONMOV
			WHERE  	DispersionID 	= Par_DispersionID
			  AND	Estatus 		IN(Est_Autoriz,'E')
			  AND 	TipoMovDIspID 	IN('2','3','5','15','21','22','709');

	END IF;

	-- EXPORTAR BANCOMER
	IF(Par_NumReporte = ExportaBancomer) THEN

		SELECT	d.NumCtaInstit AS CuentaAbono,	dm.CuentaDestino AS CuentaCargo,	dm.monto AS Monto,
				SUBSTRING(dm.NombreBenefi,1,30) AS Beneficiario,SUBSTRING(dm.Descripcion,1,30) AS Descripcion,
				SUBSTRING(dm.DispersionID,1,6) AS Referencia,SUBSTRING(dm.Identificacion,1,13) AS RFC,
				CASE WHEN Var_MonedaBaseID 	= MonedaPesos   THEN 'MXP'
					 WHEN Var_MonedaBaseID  = MonedaDolares THEN 'USD'
					 WHEN Var_MonedaBaseID  = MonedaEuros	THEN 'EUR'
				ELSE m.DescriCorta
				END AS Moneda
			FROM DISPERSIONMOV dm
				INNER JOIN DISPERSION d	ON dm.DispersionID=d.FolioOperacion
				INNER JOIN PARAMETROSSIS ps	ON dm.EmpresaID=ps.EmpresaID
				INNER JOIN MONEDAS m ON m.MonedaId	= Var_MonedaBaseID
			WHERE	dm.DispersionID		=	Par_DispersionID
			  AND 	dm.TipoMovDIspID IN ('2','3','5','15','21','22','103','709')
			  AND 	dm.Estatus 			IN( Est_Autoriz,'E');

	END IF;


	-- EXPORTAR ARCHIVO ORDEN DE PAGO
	IF(Par_NumReporte = ExportaSantander AND Par_TipoArchivo=TipoOrdenPago) THEN

		-- ACTUALIZAMOS EL CAMPO DEL ARCHIVO Y LA FECHA DE GENERACION
        UPDATE DISPERSIONMOV DIS
		INNER JOIN  CREDITOS CRE ON CRE.CreditoID= DIS.CreditoID
		INNER JOIN 	SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
		SET 	DIS.NomArchivoGenerado = Par_NombreArchivo,
				DIS.FechaGenArch = Var_FechaSistema,
				DIS.EmpresaID	 = Par_EmpresaID,
				DIS.Usuario		 = Aud_Usuario,
				DIS.FechaActual	 = Aud_FechaActual,
				DIS.DireccionIP  = Aud_DireccionIP,
				DIS.ProgramaID   = Aud_ProgramaID,
				DIS.Sucursal	 = Aud_Sucursal,
				DIS.NumTransaccion = Aud_NumTransaccion
		WHERE DIS.DispersionID =	Par_DispersionID
			AND	DIS.FormaPago = Var_OrdendePago
			AND	DIS.Estatus 	= Est_Autoriz
			AND DIS.NomArchivoGenerado = Cadena_Vacia;


		DELETE 	FROM TMPARCHIVODISPERSION
			WHERE NumTransaccion = Aud_NumTransaccion ;
		SET @Var_ID := 0;
		INSERT INTO TMPARCHIVODISPERSION(IDTmp,	NumTransaccion,		ClaveDispMov,	DispersionID)
		SELECT	(@Var_ID :=  @Var_ID+1),	Aud_NumTransaccion,		ClaveDispMov,		DispersionID
			FROM DISPERSIONMOV dm
				INNER JOIN DISPERSION d	ON dm.DispersionID=d.FolioOperacion
				INNER JOIN TIPOSMOVTESO tip ON tip.TipoMovTesoID=dm.TipoMovDIspID
				INNER JOIN PARAMETROSSIS ps	ON dm.EmpresaID=ps.EmpresaID
			WHERE	dm.DispersionID	=	Par_DispersionID
			AND 	dm.FormaPago 	= Var_OrdendePago
			AND 	dm.Estatus 		= Est_Autoriz
			AND 	dm.NomArchivoGenerado = Par_NombreArchivo;

		SELECT COUNT(IDTmp)
			INTO Var_IDTmp
			FROM TMPARCHIVODISPERSION
			WHERE NumTransaccion = Aud_NumTransaccion ;

		SET Var_Aux1 := 0;

		WHILE( Var_Aux1 <  Var_IDTmp )DO

			SELECT ClaveDispMov,	DispersionID
				INTO Var_ClaveDispMov,	Var_DispersionID
				FROM TMPARCHIVODISPERSION
				WHERE NumTransaccion = Aud_NumTransaccion LIMIT Var_Aux1,1;

			CALL REFORDENPAGOSANACT(
				Var_DispersionID,		Var_ClaveDispMov,	Cadena_Vacia,		ACT_Enviada,		SalidaNO,
				Par_NumErr, 			Par_ErrMen, 		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP, 		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE TerminaStore;
			END IF;

			SET Var_Aux1 := Var_Aux1 + 1;
		END WHILE;

		DELETE 	FROM TMPARCHIVODISPERSION
			WHERE NumTransaccion = Aud_NumTransaccion ;

		SELECT	RPAD(IFNULL(d.NumCtaInstit,EspacioBlanco),16,EspacioBlanco) AS CuentaCargo,
				RPAD(IFNULL(dm.CuentaDestino,EspacioBlanco),20,EspacioBlanco) AS ClaveDispMov,
				RPAD(IFNULL(DATE_FORMAT(Var_FechaSistema, "%d/%m/%Y"),EspacioBlanco),10,EspacioBlanco) AS FechaSistema,
				RPAD(IFNULL(DATE_FORMAT(IFNULL(rf.FechaVencimiento,dm.FechaEnvio), "%d/%m/%Y"),EspacioBlanco),10,EspacioBlanco) AS FechaEnvio,
				SUBSTRING(RPAD(IFNULL(dm.CuentaDestino,Cadena_Vacia),13,EspacioBlanco),1,13) AS RFC,
				SUBSTRING(RPAD(IFNULL(FNLIMPIACARACTERESGEN(REPLACE(UPPER(dm.NombreBenefi),'Ñ','N'),"OR"),Cadena_Vacia),60,EspacioBlanco),1,60) AS Beneficiario,
				LPAD(IFNULL(REPLACE(CAST(dm.Monto AS CHAR),'.',''),0),16,0) AS Monto,
				SUBSTRING(RPAD(IFNULL(FNLIMPIACARACTERESGEN(REPLACE(UPPER(dm.Descripcion),'Ñ','N'),"OR"),EspacioBlanco),30,EspacioBlanco),1,30) AS Descripcion,
				RPAD(CONCAT(dm.DispersionID,'X',dm.ClaveDispMov,'X',"ORDEN DE PAGO",IFNULL(dm.CreditoID, EspacioBlanco)),60,EspacioBlanco) AS Concepto,
				Var_SiEnvia AS ClaveSucursales,
				RPAD(EspacioBlanco,4,EspacioBlanco) AS ClaveSucursal,
				Var_Efectivo AS TipoPago
			FROM DISPERSIONMOV dm
				INNER JOIN DISPERSION d	ON dm.DispersionID=d.FolioOperacion
				INNER JOIN TIPOSMOVTESO tip ON tip.TipoMovTesoID=dm.TipoMovDIspID
				INNER JOIN PARAMETROSSIS ps	ON dm.EmpresaID=ps.EmpresaID
				LEFT OUTER JOIN REFORDENPAGOSAN rf ON dm.DispersionID = rf.FolioOperacion
												 and dm.ClaveDispMov = rf.ClaveDispMov
												 and rf.Estatus in ('G','E')
			WHERE	dm.DispersionID	=	Par_DispersionID
				AND 	dm.FormaPago = Var_OrdendePago
				AND 	dm.Estatus = Est_Autoriz
                AND dm.NomArchivoGenerado = Par_NombreArchivo;


	END IF;
	-- EXPORTAR ARCHIVO TRANSFERENCIA SANTANDER
	IF(Par_NumReporte = ExportaSantander AND Par_TipoArchivo=TipoTransSanta) THEN
		-- ACTUALIZAMOS EL CAMPO DEL ARCHIVO Y LA FECHA DE GENERACION
        UPDATE DISPERSIONMOV DIS
		INNER JOIN  CREDITOS CRE ON CRE.CreditoID= DIS.CreditoID
		INNER JOIN 	SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
		SET 	DIS.NomArchivoGenerado = Par_NombreArchivo,
				DIS.FechaGenArch = Var_FechaSistema,
				DIS.EmpresaID	 = Par_EmpresaID,
				DIS.Usuario		 = Aud_Usuario,
				DIS.FechaActual	 = Aud_FechaActual,
				DIS.DireccionIP  = Aud_DireccionIP,
				DIS.ProgramaID   = Aud_ProgramaID,
				DIS.Sucursal	 = Aud_Sucursal,
				DIS.NumTransaccion = Aud_NumTransaccion
		WHERE DIS.DispersionID =	Par_DispersionID
			AND	DIS.FormaPago = FormaPagoTrans
			AND	DIS.Estatus 	= Est_Autoriz
			AND DIS.NomArchivoGenerado = Cadena_Vacia
			AND length(DIS.CuentaDestino) < 18;

        -- OBTENEMOS LA INFO DE ARCHIVO GENERADO
		SELECT	Con_CodigoTranSanta AS CodigoLayaut,
				RPAD(IFNULL(d.NumCtaInstit,EspacioBlanco),18, EspacioBlanco) AS CuentaCargo,
				RPAD(IFNULL(dm.CuentaDestino,EspacioBlanco),20,EspacioBlanco) AS CuentaAbono,
				LPAD(IFNULL(REPLACE(CAST(dm.Monto AS CHAR),'.',''),0),18,0) AS Monto,
				RPAD(SUBSTRING(CONCAT(dm.DispersionID,'X',dm.ClaveDispMov,'X', "TRANSFER",IFNULL(dm.CreditoID, EspacioBlanco)),1,40),40,EspacioBlanco) AS Concepto,
				LPAD(EspacioBlanco, 40, EspacioBlanco) AS CorreoBeneficiario,
				-- DATOS ADICIONALES
				LPAD(SUBSTRING(IFNULL(FNLIMPIACARACTERESGEN(REPLACE(UPPER(dm.Descripcion),'Ñ','N'),"OR"),Cadena_Vacia),1,30),30,EspacioBlanco) AS Descripcion,
				LPAD(SUBSTRING(IFNULL(FNLIMPIACARACTERESGEN(REPLACE(UPPER(dm.NombreBenefi),'Ñ','N'),"OR"),Cadena_Vacia),1,30),30,EspacioBlanco) AS Beneficiario,
				LPAD(SUBSTRING(IFNULL(dm.DispersionID,Cadena_Vacia),1,6),7,EspacioBlanco) AS Referencia,
				LPAD(SUBSTRING(LPAD(IFNULL(dm.Identificacion,Cadena_Vacia),13,EspacioBlanco),1,13),13,EspacioBlanco) AS RFC,
				CASE WHEN Var_MonedaBaseID 	= MonedaPesos   THEN 'MXP'
					 WHEN Var_MonedaBaseID  = MonedaDolares THEN 'USD'
					 WHEN Var_MonedaBaseID  = MonedaEuros	THEN 'EUR'
				ELSE IFNULL(m.DescriCorta,Cadena_Vacia)
				END AS Moneda,
				-- DATOS PARA ACTUALIZAR EL ESTATUS
				dm.TipoMovDIspID,
				RPAD(IFNULL(DATE_FORMAT(Var_FechaSistema, "%d%m%Y"),EspacioBlanco),8,EspacioBlanco) AS FechaSistema
			FROM DISPERSIONMOV dm
				INNER JOIN DISPERSION d	ON dm.DispersionID=d.FolioOperacion
				INNER JOIN PARAMETROSSIS ps	ON dm.EmpresaID=ps.EmpresaID
				INNER JOIN MONEDAS m ON m.MonedaId	= Var_MonedaBaseID
				INNER JOIN TIPOSMOVTESO tip ON tip.TipoMovTesoID=dm.TipoMovDIspID
				INNER JOIN CREDITOS Cre ON dm.CreditoID = Cre.CreditoID
			WHERE	dm.DispersionID	= Par_DispersionID
				AND	dm.FormaPago = FormaPagoTrans
				AND	dm.Estatus 	= Est_Autoriz
				AND	d.InstitucionID=InstitucionSan
                AND dm.NomArchivoGenerado = Par_NombreArchivo;
	END IF;

-- EXPORTAR TRANSFERENCIA DE OTROS A TRAVES DE SANTANDER
	IF(Par_NumReporte = ExportaSantander AND Par_TipoArchivo=TipoTransOtros) THEN
		-- ACTUALIZAMOS EL CAMPO DEL ARCHIVO Y LA FECHA DE GENERACION
        UPDATE DISPERSIONMOV DIS
		INNER JOIN  CREDITOS CRE ON CRE.CreditoID= DIS.CreditoID
		INNER JOIN 	SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
		SET 	DIS.NomArchivoGenerado = Par_NombreArchivo,
				DIS.FechaGenArch = Var_FechaSistema,
				DIS.EmpresaID	 = Par_EmpresaID,
				DIS.Usuario		 = Aud_Usuario,
				DIS.FechaActual	 = Aud_FechaActual,
				DIS.DireccionIP  = Aud_DireccionIP,
				DIS.ProgramaID   = Aud_ProgramaID,
				DIS.Sucursal	 = Aud_Sucursal,
				DIS.NumTransaccion = Aud_NumTransaccion
		WHERE DIS.DispersionID =	Par_DispersionID
			AND	DIS.FormaPago = FormaPagoTrans
			AND	DIS.Estatus 	= Est_Autoriz
			AND DIS.NomArchivoGenerado = Cadena_Vacia
			AND length(DIS.CuentaDestino) >= 18;



        -- OBTENEMOS LA INFO DE ARCHIVO GENERADO
		SELECT	Con_CodigoTranOtros AS CodigoLayaut,
				RPAD(IFNULL(d.NumCtaInstit,EspacioBlanco),18, EspacioBlanco) AS CuentaCargo,
				RPAD(IFNULL(dm.CuentaDestino,EspacioBlanco),20,EspacioBlanco) AS CuentaAbono,
				LPAD(IFNULL(cat.ClaveTransfer,EspacioBlanco),5, Entero_Cero) AS BancoReceptor,
				RPAD(SUBSTRING(IFNULL(FNLIMPIACARACTERESGEN(REPLACE(UPPER(dm.NombreBenefi),'Ñ','N'),"OR"),Cadena_Vacia),1,40),40,EspacioBlanco) AS Beneficiario,
				LPAD(SucursalCtaAbo,4,Entero_Cero) AS SucursalID,
				LPAD(IFNULL(REPLACE(CAST(dm.Monto AS CHAR),'.',''),0),18,0) AS Monto,
				RPAD(NumPlazaBanxico,5, EspacioBlanco)AS PlazaBanxico,
				RPAD(SUBSTRING(CONCAT(dm.DispersionID,'X',dm.ClaveDispMov,'X',"TRANSFER",IFNULL(dm.CreditoID, EspacioBlanco)),1,40),40,EspacioBlanco) AS Concepto,
				LPAD(SUBSTRING(IFNULL(dm.DispersionID,Cadena_Vacia),1,7),7,EspacioBlanco) AS Referencia,
				LPAD(EspacioBlanco, 40, EspacioBlanco) AS CorreoBeneficiario,
				-- DATOS ADICIONALES
				SUBSTRING(IFNULL(FNLIMPIACARACTERESGEN(REPLACE(UPPER(dm.Descripcion),'Ñ','N'),"OR"),Cadena_Vacia),1,30) AS Descripcion,
				SUBSTRING(IFNULL(dm.Identificacion,Cadena_Vacia),1,13) AS RFC,
				CASE WHEN Var_MonedaBaseID 	= MonedaPesos   THEN 'MXP'
					 WHEN Var_MonedaBaseID  = MonedaDolares THEN 'USD'
					 WHEN Var_MonedaBaseID  = MonedaEuros	THEN 'EUR'
				ELSE IFNULL(m.DescriCorta,Cadena_Vacia)
				END AS Moneda,
				dm.TipoMovDIspID
			FROM DISPERSIONMOV dm
				INNER JOIN DISPERSION d	ON dm.DispersionID=d.FolioOperacion
				INNER JOIN PARAMETROSSIS ps	ON dm.EmpresaID=ps.EmpresaID
				INNER JOIN MONEDAS m ON m.MonedaId	= Var_MonedaBaseID
				INNER JOIN TIPOSMOVTESO tip ON tip.TipoMovTesoID=dm.TipoMovDIspID
				INNER JOIN INSTITUCIONES ins ON  SUBSTR(dm.CuentaDestino, 1, 3)=ins.Folio
				INNER JOIN CATBANCOSTRANFER cat ON cat.BancoID=ins.ClaveParticipaSpei
				INNER JOIN CREDITOS Cre ON dm.CreditoID = Cre.CreditoID
			WHERE dm.DispersionID =	Par_DispersionID
			  AND dm.FormaPago = FormaPagoTrans
			  AND dm.Estatus 	= Est_Autoriz
              AND dm.NomArchivoGenerado = Par_NombreArchivo;

	END IF;

	CALL DISPERSIONMOVACT(
		Entero_Cero,	Par_DispersionID,	Cadena_Vacia,		Cadena_Vacia,		Act_Exportada,
        Entero_Cero,	SalidaNO,			Par_NumErr, 		Par_ErrMen, 		Entero_Cero,
        Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID,
        Aud_Sucursal,	Aud_NumTransaccion);

	IF (Par_NumErr <> Entero_Cero)THEN
		LEAVE TerminaStore;
	END IF;


END TerminaStore$$