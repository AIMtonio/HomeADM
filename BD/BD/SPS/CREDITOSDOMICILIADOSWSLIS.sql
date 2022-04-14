DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSDOMICILIADOSWSLIS`;
DELIMITER $$

CREATE PROCEDURE `CREDITOSDOMICILIADOSWSLIS`(
# ================================================================
# ------ STORE PARA LA LISTA DE CREDITOS DOMICILIADOS (WS) -------
# ================================================================
	Par_EmpresaID			INT(11),			-- Numero de la Empresa a Consultar
	Par_FechaInicio			DATE,				-- Fecha de Inicio
    Par_FechaFin			DATE,				-- Fecha de Fin
    Par_InstitNominaID		VARCHAR(500),	    -- Numero de Institucion de Nomina
    Par_ProductoCreditoID	INT(11),			-- Numero de Producto de Credito

    Par_Estatus				VARCHAR(10),		-- Estatus del Credito
    Par_TipoCuenta			VARCHAR(20),		-- Tipo de Cuenta
    Par_BancoID				INT(11),			-- Numero de Institucion Bancaria
    Par_TipoDomiciliacion	VARCHAR(10),		-- Tipo de Domiciliacion
    Par_CuotasVencidas		INT(11),			-- Numero de Cuotas Vencidas

    Par_EnListaNegra		CHAR(1),			-- Indica si el cliente esta en lista Negra
    Par_CreditoID			BIGINT(12),			-- Numero de Credito

	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
		)
TerminaStore:BEGIN

    -- Declaracion de Variables
    DECLARE Var_Sentencia 		VARCHAR(10000);	-- Almacena la Sentencia de la Consulta
    DECLARE Var_FechaSistema	DATE;			-- Almacena la Fecha del Sistema
	DECLARE Var_ConsecutivoID	INT(11);   		-- Variable consecutivo
	DECLARE Var_NumRegistros	INT(11);		-- Almacena el Numero de Registros
	DECLARE Var_Contador		INT(11);		-- Contador

    DECLARE Var_AmortizacionID	INT(11);		-- Almacena el Numero de Amortizacion
    DECLARE Var_CreditoID		BIGINT(12);		-- Almacena el Numero de Credito
	DECLARE Var_FechaExigible	DATE;			-- Almacena la Fecha Exigible de la Amortizacion
    DECLARE Var_DiasAtraso		INT(11);		-- Almacena los Dias de Atraso
	DECLARE Var_InstitNominaIDInt   INT(11);    -- Institucion Nomina Tipo Int
	DECLARE Var_FechaCurrentAmor 	DATE;		-- Almacena la fecha de la amortización que corre al día o futura


	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);		-- Entero Cero
    DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal Cero
	DECLARE Cadena_Vacia   		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	SalidaSI        	CHAR(1);		-- Salida: SI

    DECLARE	SalidaNO        	CHAR(1);		-- Salida: NO
    DECLARE ConstanteSI			CHAR(1);		-- Constante: SI
	DECLARE ConstanteNO			CHAR(1);		-- Constante: NO
	DECLARE Est_Activo			CHAR(1);		-- Estatus: Activo
	DECLARE Est_Vigente     	CHAR(1);		-- Estatus: Vigente

    DECLARE Est_Vencido     	CHAR(1);		-- Estatus: Vencido
	DECLARE Est_Castigado     	CHAR(1);		-- Estatus: Castigado
   	DECLARE Est_Afiliada		CHAR(1);		-- Estatus Domiciliacion: Afiliada
	DECLARE Aplica_Credito		CHAR(1);		-- Aplica para: Credito
    DECLARE Aplica_Ambas		CHAR(1);		-- Aplica para: Ambas

    DECLARE Tipo_Externa		CHAR(1);		-- Tipo Cuenta: Externa
    DECLARE Est_Incapacidad		CHAR(1);		-- Estatus: Incapacidad
    DECLARE PersonaMoral		CHAR(1);		-- Tipo Persona: Moral
    DECLARE DescMismoBanco		VARCHAR(20);	-- Descripcion Mismo Banco
    DECLARE DescOtrosBancos		VARCHAR(20);	-- Descripcion Otros Bancos

    DECLARE DescTodos			VARCHAR(10);	-- Descripcion: todos
    DECLARE DescVigentes		VARCHAR(10);	-- Descripcion: vigentes
    DECLARE DescVencidos		VARCHAR(10);	-- Descripcion: vencidos
    DECLARE DescAtrasados		VARCHAR(10);	-- Descripcion: atrasados
    DECLARE DescCastigo			VARCHAR(10);	-- Descripcion: castigo

    DECLARE Est_Atrasado		CHAR(1);		-- Estatus Atrasado
    DECLARE TipoActual			VARCHAR(20);	-- Tipo Actual
    DECLARE TipoVencida			VARCHAR(20);	-- Tipo Vencida
    DECLARE TipoFutura			VARCHAR(20);	-- Tipo Futura

    DECLARE Lis_Empresa			INT(11);		-- Lista de Empresa
	DECLARE Lis_Institucion		INT(11);		-- Lista de Institucion de Nomina
	DECLARE Lis_Registros		INT(11);		-- Lista de Registros
	DECLARE Lis_Producto		INT(11);		-- Lista de Producto
	DECLARE Lis_TipoCuenta		INT(11);		-- Lista de Tipo de Cuenta

	DECLARE Lis_InstBancaria	INT(11);		-- Lista de Institucion Bancaria
	DECLARE Lis_PlanPagos		INT(11);		-- Lista de Plan de Pagos de los Creditos
	DECLARE CeroCadena          CHAR(1);        -- Valor cero en cadena

    -- Asignacion de Constantes
	SET Entero_Cero				:= 0; 				-- Entero Cero
    SET Decimal_Cero        	:= 0.00;			-- Decimal Cero
	SET Cadena_Vacia			:= '';    			-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	SalidaSI        		:= 'S';				-- Salida: SI

    SET	SalidaNO        		:= 'N'; 			-- Salida: NO
    SET ConstanteSI				:= 'S';				-- Constante: SI
    SET ConstanteNO				:= 'N';				-- Constante: NO
	SET Est_Activo				:= 'A';				-- Estatus: Activo
	SET Est_Vigente	    		:= 'V'; 			-- Estatus: Vigente

    SET Est_Vencido     		:= 'B'; 			-- Estatus: Vencido
	SET Est_Castigado     		:= 'K'; 			-- Estatus: Castigado
    SET Est_Afiliada			:= 'A';				-- Estatus Domiciliacion: Afiliada
	SET Aplica_Credito			:= 'C';				-- Aplica para: Credito
    SET Aplica_Ambas			:= 'A';				-- Aplica para: Ambas

	SET Tipo_Externa			:= 'E';				-- Tipo Cuenta: Externa
    SET Est_Incapacidad			:= 'I';				-- Estatus: Incapacidad
    SET PersonaMoral			:= 'M';				-- Tipo Persona: Moral
    SET DescMismoBanco			:= 'mismo_banco';	-- Descripcion Mismo Banco
    SET DescOtrosBancos			:= 'otros_bancos';	-- Descripcion Otros Bancos

    SET DescTodos				:= 'todos';			-- Descripcion: todos
    SET DescVigentes			:= 'vigentes';		-- Descripcion: vigentes
    SET DescVencidos			:= 'vencidos';		-- Descripcion: vencidos
    SET DescAtrasados			:= 'atrasados';		-- Descripcion: atrasados
    SET DescCastigo				:= 'castigo';		-- Descripcion: castigo

    SET Est_Atrasado			:= 'A';				-- Estatus: Atrasado
    SET TipoActual				:= 'actual';		-- Tipo Actual
    SET TipoVencida				:= 'vencida';		-- Tipo Vencida
    SET TipoFutura				:= 'futura';		-- Tipo Futura

    SET Lis_Empresa				:= 1;				-- Lista de Empresa
    SET Lis_Institucion			:= 2;				-- Lista de Institucion de Nomina
    SET Lis_Registros			:= 3;				-- Lista de Registros de Creditos
    SET Lis_PlanPagos			:= 4;				-- Lista de Plan de Pagos de los Creditos

	SET CeroCadena              := '0';             -- Valor cero en cadena

	-- 1.-  Lista de Empresa
	IF(Par_NumLis = Lis_Empresa)THEN
		SELECT LPAD(EmpresaID,4,'0') AS EmpresaID, NomCortoInstit AS  NombreEmpresa
        FROM PARAMETROSSIS
        WHERE EmpresaID = Par_EmpresaID;
    END IF;

	-- 2.-  Lista de Institucion de Nomina
	IF(Par_NumLis = Lis_Institucion)THEN
	    SET Var_InstitNominaIDInt:= CAST(Par_InstitNominaID AS unsigned);
		SELECT  LPAD(InstitNominaID,4,'0') AS InstitNominaID,	NombreInstit
		FROM INSTITNOMINA
		WHERE InstitNominaID = Var_InstitNominaIDInt;
    END IF;

    -- 3.- Lista de Registros de Creditos
	IF(Par_NumLis = Lis_Registros)THEN

		DROP TEMPORARY TABLE IF EXISTS TMPCREDITOSDOMICILIADOS;
        CREATE TEMPORARY TABLE TMPCREDITOSDOMICILIADOS(
			CreditoID			BIGINT(12)		COMMENT 'Numero de Credito',
			ClienteID  			INT(11)   		COMMENT 'Numero de Cliente',
			NombreCompleto		VARCHAR(200)	COMMENT 'Nombre Completo del Cliente',
			InstitucionID		INT(11)			COMMENT 'Numero de Institucion Bancaria',
			Folio				CHAR(3)			COMMENT 'Numero de Folio Institucion Bancaria',
			NombreInstitucion	VARCHAR(200)	COMMENT 'Nombre de la Institucion Bancaria',
			TipoCuentaSpei		INT(11)			COMMENT 'Tipo de Cuenta Spei',
			DescTipoCuenta		VARCHAR(50)		COMMENT 'Descripcion Tipo de Cuenta Spei',
			Cuenta				VARCHAR(18) 	COMMENT 'Numero de Cuenta (Clabe, Tarjeta, Numero Celular)',
			Estatus				CHAR(1) 		COMMENT 'Estatus del Credito',
			ProductoCreditoID	INT(11)			COMMENT 'Numero del Producto de Credito',
            NombreProducto      VARCHAR(200)	COMMENT 'Nombre del Producto de Credito',
			RFC      			CHAR(13)		COMMENT 'RFC del Cliente',
            EnListaNegra		CHAR(1)			COMMENT 'Indica si el Cliente se encuentra en la lista negra interna',
			Saldo				DECIMAL(14,2)	COMMENT 'Saldo del Credito a Liquidar',
			InstitNominaID      VARCHAR(50)     COMMENT 'Numero de institucion de nomina',
            NombreInstit        VARCHAR(200)    COMMENT 'Nombre de institucion de nomina',

		PRIMARY KEY(CreditoID),
		KEY INDEX_TMP_TMPCREDITOSDOMICILIADOS_1 (CreditoID),
		KEY INDEX_TMP_TMPCREDITOSDOMICILIADOS_2 (ClienteID),
		KEY INDEX_TMP_TMPCREDITOSDOMICILIADOS_3 (InstitucionID),
		KEY INDEX_TMP_TMPCREDITOSDOMICILIADOS_4 (ProductoCreditoID),
		KEY INDEX_TMP_TMPCREDITOSDOMICILIADOS_5 (RFC));

		INSERT INTO TMPCREDITOSDOMICILIADOS (
			CreditoID,				ClienteID,					NombreCompleto,			InstitucionID,			Folio,
			NombreInstitucion,		TipoCuentaSpei,				DescTipoCuenta,			Cuenta,					Estatus,
			ProductoCreditoID,		NombreProducto,				RFC,					EnListaNegra,			Saldo,
			InstitNominaID,          NombreInstit)
		SELECT
			Cre.CreditoID, 			Cre.ClienteID, 				Cli.NombreCompleto,		MAX(Ist.InstitucionID),	Cadena_Vacia,
			Cadena_Vacia,			MAX(Cta.TipoCuentaSpei),	Cadena_Vacia,			Cre.ClabeCtaDomici,		Cre.Estatus,
			Cre.ProductoCreditoID,	Cadena_Vacia,				CASE WHEN Cli.TipoPersona = PersonaMoral THEN Cli.RFCpm ELSE Cli.RFCOficial END,	ConstanteNO,
            FUNCIONTOTDEUDACRE(Cre.CreditoID),Ins.InstitNominaID, Ins.NombreInstit
		FROM
			INSTITNOMINA Ins,
			CONVENIOSNOMINA Con,
			NOMINAEMPLEADOS Nom,
			CLIENTES Cli,
			CREDITOS Cre,
			CUENTASTRANSFER Cta,
			INSTITUCIONES Ist
		WHERE Ins.InstitNominaID = Con.InstitNominaID
		  AND Con.ConvenioNominaID = Nom.ConvenioNominaID
		  AND Nom.ClienteID = Cre.ClienteID
		  AND  Cli.ClienteID = Cre.ClienteID
		  AND Ins.InstitNominaID = Cre.InstitNominaID
		  AND Cre.ClienteID = Cta.ClienteID
		  AND Cta.InstitucionID = Ist.ClaveParticipaSpei
		  AND Cre.ClabeCtaDomici = Cta.Clabe
		  -- AND Con.Estatus = Est_Activo
		  AND Con.DomiciliacionPagos = ConstanteSI
		  AND (Cre.Estatus = Est_Vigente OR Cre.Estatus = Est_Vencido OR Cre.Estatus = Est_Castigado)
		  AND Cta.EstatusDomici = Est_Afiliada
		  AND (Cta.AplicaPara = Aplica_Credito OR Cta.AplicaPara = Aplica_Ambas)
		  AND Cta.TipoCuenta = Tipo_Externa
		  AND (Nom.Estatus = Est_Activo OR Nom.Estatus = Est_Incapacidad)
		   AND (Cre.ClabeCtaDomici IS NOT NULL
					OR Cre.ClabeCtaDomici != Cadena_Vacia)
		  AND Ist.Domicilia = ConstanteSI
		  GROUP BY Cre.CreditoID;

		-- Se actualiza el Folio y Nombre de la Institucion Bancaria
		UPDATE TMPCREDITOSDOMICILIADOS Tmp
			   INNER JOIN INSTITUCIONES Ins
			ON Tmp.InstitucionID = Ins.InstitucionID
		SET Tmp.Folio = Ins.Folio,
			Tmp.NombreInstitucion = UPPER(Ins.NombreCorto);

		-- Se actualiza la Descripcion de Tipo de Cuenta Spei
		  UPDATE TMPCREDITOSDOMICILIADOS
		SET DescTipoCuenta = CASE WHEN TipoCuentaSpei = 40 THEN 'CLABE INTERBANCARIA'
								  WHEN TipoCuentaSpei = 3 THEN 'TARJETA DE DEBITO'
								  WHEN TipoCuentaSpei = 10 THEN 'NUMERO DE CELULAR' END;

		-- Se actualiza el Nombre del Producto de Credito
		UPDATE TMPCREDITOSDOMICILIADOS Tmp
			   INNER JOIN PRODUCTOSCREDITO Pro
			ON Tmp.ProductoCreditoID = Pro.ProducCreditoID
		SET Tmp.NombreProducto = Pro.Descripcion;

		-- Se actualiza si el Cliente se encuentra en la lista negra interna de la institucion
		  UPDATE TMPCREDITOSDOMICILIADOS Tmp
			   INNER JOIN PLDLISTAPERSNODESEADAS Per
			ON Tmp.RFC = Per.RFC
		SET Tmp.EnListaNegra = ConstanteSI;


		SET Var_Sentencia := ' SELECT Tmp.CreditoID,	Tmp.ClienteID,	Tmp.NombreCompleto,		Tmp.Folio,	 Tmp.NombreInstitucion, 	Tmp.TipoCuentaSpei, ';
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' Tmp.DescTipoCuenta, Tmp.Cuenta, CASE WHEN Tmp.Estatus = "V" THEN "vigente" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHEN Tmp.Estatus = "B" THEN "vencido" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHEN Tmp.Estatus = "K" THEN "castigado" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE "" END AS Estatus, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' Tmp.ProductoCreditoID,	Tmp.NombreProducto,	Tmp.EnListaNegra, Tmp.Saldo, LPAD(Tmp.InstitNominaID,4,',Entero_Cero,') AS InstitNominaID,Tmp.NombreInstit ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' FROM TMPCREDITOSDOMICILIADOS Tmp ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'	INNER JOIN AMORTICREDITO Amor ON Tmp.CreditoID = Amor.CreditoID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE Tmp.CreditoID = Amor.CreditoID ');


		SET Par_ProductoCreditoID := IFNULL(Par_ProductoCreditoID,Entero_Cero);
		IF(Par_ProductoCreditoID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Tmp.ProductoCreditoID = ', Par_ProductoCreditoID);
		END IF;

		SET Par_TipoCuenta := IFNULL(Par_TipoCuenta,Cadena_Vacia);
		SET Par_BancoID := IFNULL(Par_BancoID,Entero_Cero);

		IF(Par_TipoCuenta != Cadena_Vacia)THEN
			IF(Par_TipoCuenta = DescMismoBanco)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Tmp.InstitucionID = ', Par_BancoID);
			END IF;
			IF(Par_TipoCuenta = DescOtrosBancos)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Tmp.InstitucionID != ', Par_BancoID);
			END IF;
		END IF;

		SET Par_EnListaNegra := IFNULL(Par_EnListaNegra,Cadena_Vacia);
		IF(Par_EnListaNegra != Cadena_Vacia)THEN
			IF(Par_EnListaNegra = ConstanteSI)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Tmp.EnListaNegra = "',ConstanteSI,'"');
			END IF;
			IF(Par_EnListaNegra = ConstanteNO)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Tmp.EnListaNegra = "',ConstanteNO,'"');
			END IF;
		END IF;

		IF(Par_InstitNominaID <> CeroCadena)THEN

			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND FIND_IN_SET( Tmp.InstitNominaID, "',Par_InstitNominaID,'")>', Entero_Cero,' ');

		END IF;

		IF Par_Estatus != DescTodos THEN

			IF Par_Estatus = DescVigentes THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Amor.Estatus = "',Est_Vigente,'"');
			END IF;

			IF Par_Estatus = DescVencidos THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Amor.Estatus = "',Est_Vencido,'"');
			END IF;

			IF Par_Estatus = DescAtrasados THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Amor.Estatus = "',Est_Atrasado,'"');
			END IF;

			IF Par_Estatus = DescCastigo THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Amor.Estatus = "',Est_Castigado,'"');
			END IF;

		ELSE
		
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Amor.Estatus IN("',Est_Vigente,'", "',Est_Vencido,'", "',Est_Atrasado,'", "',Est_Castigado,'" )'); 

		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND Amor.FechaExigible > "', Fecha_Vacia ,'" AND Amor.FechaExigible <= "', Par_FechaFin,'" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'GROUP BY Tmp.CreditoID');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' ; ');

		SET @Sentencia	= (Var_Sentencia);

		PREPARE TMPCREDITOSDOMICILIADOS FROM @Sentencia;
		EXECUTE TMPCREDITOSDOMICILIADOS;
		DEALLOCATE PREPARE TMPCREDITOSDOMICILIADOS;
    END IF;

    -- 4.-Lista de Plan de Pagos de los Creditos
	IF(Par_NumLis = Lis_PlanPagos)THEN
		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

        -- Cuando el filtro de cuotas vencidas sea cero
		IF(Par_CuotasVencidas = Entero_Cero)THEN

			DROP TEMPORARY TABLE IF EXISTS TMPAMORTICREDOMICILIA;
			CREATE TEMPORARY TABLE TMPAMORTICREDOMICILIA(
				AmortizacionID		INT(11)			COMMENT 'Numero de Amortizacion',
                CreditoID			BIGINT(12)		COMMENT 'Numero de Credito',
				FechaInicio			DATE			COMMENT 'Fecha Inicio del Credito',
				FechaExigible  		DATE   			COMMENT 'Fecha Exigible',
				MontoExigible		DECIMAL(14,2)	COMMENT 'Monto Exigible',
				Monto				DECIMAL(14,2)	COMMENT 'Monto Pactado',
				DiasAtraso			INT(11)			COMMENT 'Dias de Atraso',
				Tipo				VARCHAR(20)		COMMENT 'Tipo de Amortizacion (actual,vencida,futura)',
				Estatus				CHAR(1) 		COMMENT 'Estatus de la Amortizacion',

                PRIMARY KEY(AmortizacionID,CreditoID),

				KEY INDEX_TMPAMORTICREDOMICILIA_1 (AmortizacionID),
                KEY INDEX_TMPAMORTICREDOMICILIA_2 (CreditoID),
                KEY INDEX_TMPAMORTICREDOMICILIA_3 (Tipo));

			IF(Par_Estatus = DescTodos)THEN

				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,					Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND FechaExigible <= Par_FechaFin
				AND Estatus IN(Est_Vigente,Est_Vencido,Est_Atrasado,Est_Castigado);
			
				 /*Si existe una amortizacion con FechaExigible al día de hoy, se inserta en la tabla*/
				SET Var_FechaCurrentAmor := (SELECT IFNULL(FechaExigible,Fecha_Vacia) AS FechaExigible FROM TMPAMORTICREDOMICILIA 
											WHERE CreditoID = Par_CreditoID AND Estatus = Est_Vigente 
											AND (Var_FechaSistema >= FechaInicio AND Var_FechaSistema <= FechaExigible) LIMIT 1);
																						
				IF (Var_FechaCurrentAmor >= Var_FechaSistema)THEN
					SET Var_FechaCurrentAmor := Var_FechaSistema;
				ELSE
					INSERT INTO TMPAMORTICREDOMICILIA(
						AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				MontoExigible,		
						Monto,						DiasAtraso,				Tipo,					Estatus)
					SELECT
						AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
						(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
						Entero_Cero,				Cadena_Vacia,			Estatus
					FROM AMORTICREDITO
					WHERE CreditoID = Par_CreditoID AND Estatus = Est_Vigente 
					AND (Var_FechaSistema >= FechaInicio AND Var_FechaSistema <= FechaExigible) LIMIT 1;
				END IF;
			END IF;
			

            IF(Par_Estatus = DescVigentes)THEN

				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,					Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND FechaExigible <= Par_FechaFin
				AND Estatus = Est_Vigente;
			END IF;

            IF(Par_Estatus = DescVencidos)THEN

				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,					Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND FechaExigible <= Par_FechaFin
				AND Estatus = Est_Vencido;
								
				-- Si hay una amortizacion con fecha al día de hoy, se inserta 
				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,					Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID AND Estatus = Est_Vigente
				AND (Var_FechaSistema >= FechaInicio AND Var_FechaSistema <= FechaExigible) LIMIT 1;
			END IF;

            IF(Par_Estatus = DescAtrasados)THEN

				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				MontoExigible,		
					Monto,					    DiasAtraso,				Tipo,					Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND FechaExigible <= Par_FechaFin
				AND Estatus = Est_Atrasado;
				
				-- Si hay una amortizacion con fecha al día de hoy, se inserta 
				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,					Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID AND Estatus = Est_Vigente 
				AND (Var_FechaSistema >= FechaInicio AND Var_FechaSistema <= FechaExigible) LIMIT 1;
				
			END IF;

            IF(Par_Estatus = DescCastigo)THEN

				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,					Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND FechaExigible <= Par_FechaFin
				AND Estatus = Est_Castigado;
				
				-- Si hay una amortizacion con fecha al día de hoy, se inserta  
				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,					Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID AND Estatus = Est_Vigente 
				AND (Var_FechaSistema >= FechaInicio AND Var_FechaSistema <= FechaExigible) LIMIT 1;
			END IF;

            -- Se actualiza el Tipo de Amortizacion (futura)
            UPDATE TMPAMORTICREDOMICILIA
            SET Tipo = TipoFutura
            WHERE FechaExigible > Var_FechaSistema
            AND Estatus = Est_Vigente;

			-- Se actualiza el Tipo de Amortizacion (actual)
            UPDATE TMPAMORTICREDOMICILIA
            SET Tipo = TipoActual
            WHERE FechaExigible <= Var_FechaSistema
            AND Estatus = Est_Vigente;

            -- Se actualiza el Tipo de Amortizacion (vencida)
            UPDATE TMPAMORTICREDOMICILIA
            SET Tipo = TipoVencida
            WHERE FechaExigible <= Var_FechaSistema
            AND Estatus IN(Est_Vencido,Est_Atrasado,Est_Castigado);

			SET @Var_ConsecutivoID := 0;

            DROP TEMPORARY TABLE IF EXISTS TMPAMORTICREDDIASATRA;
			CREATE TEMPORARY TABLE TMPAMORTICREDDIASATRA(
				ConsecutivoID		INT(11)			COMMENT 'Numero Consecutivo',
				AmortizacionID		INT(11)			COMMENT 'Numero de Amortizacion',
                CreditoID			BIGINT(12)		COMMENT 'Numero de Credito',
				FechaExigible  		DATE   			COMMENT 'Fecha Exigible',

                PRIMARY KEY(AmortizacionID,CreditoID),

				KEY INDEX_TMPAMORTICREDDIASATRA_1 (AmortizacionID),
                KEY INDEX_TMPAMORTICREDDIASATRA_2 (CreditoID));

			INSERT INTO TMPAMORTICREDDIASATRA(
				ConsecutivoID,		AmortizacionID,	CreditoID,	FechaExigible)
			SELECT
				@Var_ConsecutivoID:=@Var_ConsecutivoID+1,AmortizacionID,	CreditoID,	FechaExigible
			FROM TMPAMORTICREDOMICILIA
            WHERE Tipo = TipoVencida;

            -- Se obtiene el Numero de Registros
			SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPAMORTICREDDIASATRA);
			SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

			-- Se valida que el Numero de Registros sea Mayor a Cero
			IF(Var_NumRegistros > Entero_Cero)THEN
				-- Se inicializa el contador
				SET Var_Contador := 1;

				-- Se obtienen los Dias de Atraso de las Amortizaciones Vencidas
				WHILE(Var_Contador <= Var_NumRegistros) DO
					SELECT	AmortizacionID,		CreditoID,		FechaExigible
					INTO    Var_AmortizacionID,	Var_CreditoID,  Var_FechaExigible
					FROM TMPAMORTICREDDIASATRA
					WHERE ConsecutivoID = Var_Contador;

                    SET Var_DiasAtraso := (SELECT DiasAtraso FROM SALDOSCREDITOS WHERE FechaCorte = Var_FechaExigible AND CreditoID = Var_CreditoID);
                    SET Var_DiasAtraso := IFNULL(Var_DiasAtraso,Entero_Cero);

                    UPDATE TMPAMORTICREDOMICILIA Tmp1
                    INNER JOIN TMPAMORTICREDDIASATRA Tmp2
                    ON Tmp1.AmortizacionID = Tmp2.AmortizacionID
                    AND Tmp1.CreditoID = Tmp2.CreditoID
                    SET DiasAtraso = Var_DiasAtraso
                    WHERE Tmp1.AmortizacionID = Var_AmortizacionID
                    AND Tmp1.CreditoID = Var_CreditoID;

					SET Var_Contador := Var_Contador + 1;

				END WHILE; -- FIN del WHILE

			END IF; -- FIN Se valida que el Numero de Registros sea Mayor a Cero

			SELECT 	AmortizacionID,	FechaExigible,	Monto,	MontoExigible,	DiasAtraso,
					Tipo
			FROM TMPAMORTICREDOMICILIA;
		END IF;

		-- Cuando el filtro de cuotas vencidas sea mayor cero
		IF(Par_CuotasVencidas > Entero_Cero)THEN

			DROP TEMPORARY TABLE IF EXISTS TMPAMORTICREDOMICILIA;
			CREATE TEMPORARY TABLE TMPAMORTICREDOMICILIA(
				AmortizacionID		INT(11)			COMMENT 'Numero de Amortizacion',
                CreditoID			BIGINT(12)		COMMENT 'Numero de Credito',
				FechaInicio			DATE			COMMENT 'Fecha Inicio del Credito',
				FechaExigible  		DATE   			COMMENT 'Fecha Exigible',
				MontoExigible		DECIMAL(14,2)	COMMENT 'Monto Exigible',
				Monto				DECIMAL(14,2)	COMMENT 'Monto Pactado',
				DiasAtraso			INT(11)			COMMENT 'Dias de Atraso',
				Tipo				VARCHAR(20)		COMMENT 'Tipo de Amortizacion (actual,vencida,futura)',
				Estatus				CHAR(1) 		COMMENT 'Estatus de la Amortizacion',

                PRIMARY KEY(AmortizacionID,CreditoID),

				KEY INDEX_TMPAMORTICREDOMICILIA_1 (AmortizacionID),
                KEY INDEX_TMPAMORTICREDOMICILIA_2 (CreditoID),
                KEY INDEX_TMPAMORTICREDOMICILIA_3 (Tipo));

			IF(Par_Estatus = DescTodos)THEN

				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,					Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND FechaExigible <= Par_FechaFin
				AND Estatus IN(Est_Vencido,Est_Atrasado,Est_Castigado,Est_Vigente)
				LIMIT Par_CuotasVencidas;

                /*Si existe una amortizacion con FechaExigible al día de hoy, se inserta en la tabla*/
				SET Var_FechaCurrentAmor := (SELECT IFNULL(FechaExigible,Fecha_Vacia) AS FechaExigible FROM TMPAMORTICREDOMICILIA 
											WHERE CreditoID = Par_CreditoID AND Estatus = Est_Vigente 
											AND (Var_FechaSistema >= FechaInicio AND Var_FechaSistema <= FechaExigible) LIMIT 1);
											
											
				IF (Var_FechaCurrentAmor >= Var_FechaSistema)THEN
					SET Var_FechaCurrentAmor := Var_FechaSistema;
				ELSE
					INSERT INTO TMPAMORTICREDOMICILIA(
						AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				MontoExigible,		
						Monto,						DiasAtraso,				Tipo,					Estatus)
					SELECT
						AmortizacionID,				CreditoID,				FechaInicio,			FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
						(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
						Entero_Cero,				Cadena_Vacia,			Estatus
					FROM AMORTICREDITO
					WHERE CreditoID = Par_CreditoID AND Estatus = Est_Vigente 
					AND (Var_FechaSistema >= FechaInicio AND Var_FechaSistema <= FechaExigible) LIMIT 1;
				END IF;

			END IF;

            IF(Par_Estatus = DescVigentes)THEN

				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,						Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND FechaExigible <= Par_FechaFin
				AND Estatus = Est_Vigente
				LIMIT Par_CuotasVencidas;

			END IF;

            IF(Par_Estatus = DescVencidos)THEN

				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,						Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND FechaExigible <= Par_FechaFin
				AND Estatus = Est_Vencido
                LIMIT Par_CuotasVencidas;			
	
	
				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,						Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID AND Estatus = Est_Vigente 
				AND (Var_FechaSistema >= FechaInicio AND Var_FechaSistema <= FechaExigible) LIMIT 1;
				
			END IF;

            IF(Par_Estatus = DescAtrasados)THEN

				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,						Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND FechaExigible <= Par_FechaFin
				AND Estatus = Est_Atrasado
				LIMIT Par_CuotasVencidas;
				
				
				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,						Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID AND Estatus = Est_Vigente 
				AND (Var_FechaSistema >= FechaInicio AND Var_FechaSistema <= FechaExigible) LIMIT 1;
				
			END IF;

            IF(Par_Estatus = DescCastigo)THEN

				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,						Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND FechaExigible <= Par_FechaFin
				AND Estatus = Est_Castigado
				LIMIT Par_CuotasVencidas;
				
				
				INSERT INTO TMPAMORTICREDOMICILIA(
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				MontoExigible,		
					Monto,						DiasAtraso,				Tipo,					    Estatus)
				SELECT
					AmortizacionID,				CreditoID,				FechaInicio,				FechaExigible,				FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					(Capital + Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones) AS Monto,
					Entero_Cero,				Cadena_Vacia,			Estatus
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID AND Estatus = Est_Vigente 
				AND (Var_FechaSistema >= FechaInicio AND Var_FechaSistema <= FechaExigible) LIMIT 1;
				
			END IF;

            -- Se actualiza el Tipo de Amortizacion (futura)
            UPDATE TMPAMORTICREDOMICILIA
            SET Tipo = TipoFutura
            WHERE FechaExigible > Var_FechaSistema
            AND Estatus = Est_Vigente;

			-- Se actualiza el Tipo de Amortizacion (actual)
            UPDATE TMPAMORTICREDOMICILIA
            SET Tipo = TipoActual
            WHERE FechaExigible = Var_FechaSistema
            AND Estatus = Est_Vigente;

            -- Se actualiza el Tipo de Amortizacion (vencida)
            UPDATE TMPAMORTICREDOMICILIA
            SET Tipo = TipoVencida
            WHERE FechaExigible <= Var_FechaSistema
            AND Estatus IN(Est_Vencido,Est_Atrasado,Est_Castigado);

			SET @Var_ConsecutivoID := 0;

            DROP TEMPORARY TABLE IF EXISTS TMPAMORTICREDDIASATRA;
			CREATE TEMPORARY TABLE TMPAMORTICREDDIASATRA(
				ConsecutivoID		INT(11)			COMMENT 'Numero Consecutivo',
				AmortizacionID		INT(11)			COMMENT 'Numero de Amortizacion',
                CreditoID			BIGINT(12)		COMMENT 'Numero de Credito',
				FechaExigible  		DATE   			COMMENT 'Fecha Exigible',

                PRIMARY KEY(AmortizacionID,CreditoID),

				KEY INDEX_TMPAMORTICREDDIASATRA_1 (AmortizacionID),
                KEY INDEX_TMPAMORTICREDDIASATRA_2 (CreditoID));

			INSERT INTO TMPAMORTICREDDIASATRA(
				ConsecutivoID,		AmortizacionID,	CreditoID,	FechaExigible)
			SELECT
				@Var_ConsecutivoID:=@Var_ConsecutivoID+1,AmortizacionID,	CreditoID,	FechaExigible
			FROM TMPAMORTICREDOMICILIA
            WHERE Tipo = TipoVencida;

            -- Se obtiene el Numero de Registros
			SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPAMORTICREDDIASATRA);
			SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

			-- Se valida que el Numero de Registros sea Mayor a Cero
			IF(Var_NumRegistros > Entero_Cero)THEN
				-- Se inicializa el contador
				SET Var_Contador := 1;

				-- Se obtienen los Dias de Atraso de las Amortizaciones Vencidas
				WHILE(Var_Contador <= Var_NumRegistros) DO
					SELECT	AmortizacionID,		CreditoID,		FechaExigible
					INTO    Var_AmortizacionID,	Var_CreditoID,  Var_FechaExigible
					FROM TMPAMORTICREDDIASATRA
					WHERE ConsecutivoID = Var_Contador;

                    SET Var_DiasAtraso := (SELECT DiasAtraso FROM SALDOSCREDITOS WHERE FechaCorte = Var_FechaExigible AND CreditoID = Var_CreditoID);
                    SET Var_DiasAtraso := IFNULL(Var_DiasAtraso,Entero_Cero);

                    UPDATE TMPAMORTICREDOMICILIA Tmp1
                    INNER JOIN TMPAMORTICREDDIASATRA Tmp2
                    ON Tmp1.AmortizacionID = Tmp2.AmortizacionID
                    AND Tmp1.CreditoID = Tmp2.CreditoID
                    SET DiasAtraso = Var_DiasAtraso
                    WHERE Tmp1.AmortizacionID = Var_AmortizacionID
                    AND Tmp1.CreditoID = Var_CreditoID;

					SET Var_Contador := Var_Contador + 1;

				END WHILE; -- FIN del WHILE

			END IF; -- FIN Se valida que el Numero de Registros sea Mayor a Cero

			SELECT 	AmortizacionID,	FechaExigible,	Monto,	MontoExigible,	DiasAtraso,
					Tipo
			FROM TMPAMORTICREDOMICILIA;
		END IF;
	END IF;

END TerminaStore$$