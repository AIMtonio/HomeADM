-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONAPORTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONAPORTAPRO`;
DELIMITER $$


CREATE PROCEDURE `DISPERSIONAPORTAPRO`(
# ===============================================================
# ---- SP PARA OBTENER LAS APORTACIONES PARA DISPERSION ---------
# ===============================================================
	Par_InstitucionID 		INT(11),
	Par_NumCtaInstit 		VARCHAR(20),
	Par_Fecha				DATE,

	Par_Salida				CHAR(1),
	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen  	VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Credito				BIGINT(12);
	DECLARE Var_NumSucursal			INT(11);
	DECLARE Var_Reg					INT(11);
	DECLARE Var_MaxReg				INT(11);
	DECLARE NumError				INT(11);
	DECLARE ErrorMen				VARCHAR(200);
	DECLARE CtaPrincipal			CHAR(1);
	DECLARE Var_Institucion			INT(11);
	DECLARE Var_CtaInstitu			VARCHAR(20);
	DECLARE FolioOperac				INT(11);
	DECLARE Var_CuentaAhoID			BIGINT(12);
	DECLARE Var_MontoAporta			DECIMAL(14,4);
	DECLARE Var_SoliciCredID		INT(11);
	DECLARE Var_NomCliente			VARCHAR(200);
	DECLARE VarRFCcte				VARCHAR(13);
	DECLARE VarRFCPMcte				VARCHAR(13);
	DECLARE VarTipoPerson			CHAR(1);
	DECLARE VarCuentaCLABE			VARCHAR(18);
	DECLARE RegistroSalida			INT(11);
	DECLARE Var_ForComApe			CHAR(1);
	DECLARE Var_MontoComAp			DECIMAL(12,4);
	DECLARE Var_IVAComAp			DECIMAL(12,4);
	DECLARE Var_TipoDispersion		CHAR(1);
	DECLARE Var_FormaPago			INT(11);
	DECLARE TipoMovDis				CHAR(4);
	DECLARE Var_NumAportaciones			INT(11); -- variable para saber si existen o no creditos para ministrar
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_ForCobSeg			CHAR(1);
	DECLARE Var_MontoSegVid			DECIMAL(12,2);
    DECLARE	Var_Consecutivo			BIGINT(12);
    DECLARE Var_Control 			VARCHAR(100);
	DECLARE VarTipoChequera			CHAR(2);
	DECLARE Var_MontoCargoDisp		DECIMAL(12,4);
	DECLARE Var_ProductoCreditoID	INT(11);
	DECLARE Var_Dispersiones 		CHAR(10);			-- cambia de acuerdo a los tipos de dispersion habilitados
	DECLARE Var_SpeiHab				CHAR(1);			-- indica el estatus de habilitado de SPEI
	DECLARE Var_AportacionID		INT(11);
	DECLARE Var_AmortizacionID		INT(11);
	DECLARE Var_CuentaTranID		INT(11);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,4);
	DECLARE EstatPagada			CHAR(1);
	DECLARE SalidaSi           	CHAR(1);
	DECLARE SalidaNo           	CHAR(1);
	DECLARE TipoDisperSPEI     	CHAR(1);
    DECLARE TipoDisperOrden		CHAR(1);
	DECLARE TipoDisperCheque   	CHAR(1);
	DECLARE TipoMovDisSPEI     	CHAR(4);
	DECLARE TipoMovDisCheq     	CHAR(4);
    DECLARE TipoMovDisOrden		CHAR(4);
	DECLARE PerFisica          	CHAR(1);
	DECLARE PerMoral           	CHAR(1);
	DECLARE Descrip            	VARCHAR(40);
	DECLARE DescripSPEI        	VARCHAR(40);
	DECLARE DescripCheq		   	VARCHAR(40);
    DECLARE DescripOrdenPago	VARCHAR(50);
	DECLARE EstatusPendien	   	CHAR(1);
	DECLARE ForComApDeduc      	CHAR(1);
	DECLARE ForComApFinanc     	CHAR(1);
	DECLARE FormaPagoSPEI      	INT(11);
	DECLARE FormaPagoCheque	   	INT(11);
    DECLARE FormaPagoOrden	   	INT(11);
	DECLARE Bloq_DispCred      	INT(11);
	DECLARE Mov_Bloqueo        	CHAR(1);
	DECLARE Fecha				DATE;
	DECLARE SiHabilita			CHAR(1);
	DECLARE ValorParam			VARCHAR(100);
	DECLARE Var_SiHabilita		CHAR(1);
	DECLARE FechaSis			DATE;
	DECLARE ForCobDeduc			CHAR(1);
	DECLARE ForCobFinanc		CHAR(1);
	DECLARE Est_SpeiHab			CHAR(1);
	DECLARE Var_TransaccionID	BIGINT(20);
    DECLARE Aux_Spei			INT(11);
    DECLARE VarNumSpeiCan		INT(11);
    DECLARE Var_Folio			BIGINT(20);
    DECLARE Var_ClaveR			VARCHAR(20);
    DECLARE Var_Descripcion		VARCHAR(150);
    DECLARE Var_AportBenef		BIGINT  (20) UNSIGNED;
    DECLARE Var_TipoBloqueo		INT(11);				-- Tipo de Bloque por Dispersion
	DECLARE Var_DescripBloqueo  VARCHAR(100);
	DECLARE Var_No 				CHAR(1);
    
	-- Asignacion de Constantes
	SET Entero_Cero         := 0;
	SET Cadena_Vacia        := '';
	SET EstatPagada         := 'P';
	SET SalidaSi            := 'S';
	SET SalidaNo            := 'N';
	SET TipoDisperSPEI      := 'S';
	SET TipoDisperCheque    := 'C';
    SET TipoDisperOrden   	:= 'O';
	SET CtaPrincipal        := 'S';
	SET TipoMovDisSPEI      := '709';
	SET TipoMovDisCheq      := '12';
    SET TipoMovDisOrden     := '700';
	SET PerFisica           := 'F';
	SET PerMoral            := 'M';
	SET DescripSPEI         := 'SPEI APORTACIONES';
	SET DescripCheq         := 'CHEQUE PAGADO DES CREDITO';
    SET DescripOrdenPago	:= 'ORDEN PAGO DISPERSION APORTACION';
	SET EstatusPendien      := 'P';
	SET ForComApDeduc       := 'D';
	SET ForComApFinanc      := 'F';
	SET FormaPagoSPEI       := 1;
	SET FormaPagoCheque     := 2;
    SET FormaPagoOrden		:= 5;
	SET Bloq_DispCred       := 1;       -- Tipo de Bloqueo por Dispersion de Credito
	SET Mov_Bloqueo         := 'B';     -- Movimiento de Bloqueo de Saldo
	SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET SiHabilita			:= "S";
	SET ValorParam			:= "HabilitaFechaDisp";
	SET ForCobDeduc			:= 'D';
	SET ForCobFinanc		:= 'F';
	SET	Est_SpeiHab			:='S';
	SET Var_Descripcion  	:= 'CANCELACION POR DISPERSION EN TESORERIA';
	SET Var_TipoBloqueo		:= 1;				-- Tipo de Bloque por Dispersion
	SET Var_DescripBloqueo  := 'BLOQUEO POR DISPERSION EN TESORERIA';
	SET Var_No  			:= 'N';
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-DISPERSIONAPORTAPRO');
		END;

		SELECT ValorParametro INTO Var_SiHabilita
			FROM PARAMGENERALES WHERE LlaveParametro=ValorParam;

		IF Var_SiHabilita=SiHabilita THEN
			SET Fecha :=Par_Fecha;
		ELSE
			SET Fecha :=Var_FechaSistema;
		END IF;

		SET Var_SpeiHab := (SELECT Habilitado FROM PARAMETROSSPEI LIMIT 1);

		IF Var_SpeiHab = Est_SpeiHab  THEN
			SET Var_Dispersiones :=	'C,O';
		ELSE
			SET	Var_Dispersiones :=	'S,C,O';
		END IF;

		

		IF(IFNULL(Par_EmpresaID,Entero_Cero) = Entero_Cero )THEN
			SET	Par_NumErr 		:= 1;
			SET	Par_ErrMen		:= 'La Empresa esta vacia';
            SET Var_Control		:= '';
            SET Var_Consecutivo := Par_EmpresaID;
			LEAVE ManejoErrores;
		END IF;

		-- se valida que exixte el numero de institucion
		SET Var_Institucion := IFNULL((SELECT InstitucionID
											FROM 	INSTITUCIONES
											WHERE 	InstitucionID = Par_InstitucionID ),Entero_Cero);

		IF(IFNULL(Var_Institucion,Entero_Cero) = Entero_Cero )THEN
			SET	Par_NumErr 		:= 1;
			SET	Par_ErrMen		:= 'La Institucion especificada no Existe';
            SET Var_Control		:= 'institucionID';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		-- se valida que exixte el numero de cuenta de la institucion
		SET Var_CtaInstitu := IFNULL((SELECT NumCtaInstit
										FROM 	CUENTASAHOTESO
										WHERE 	InstitucionID	= Par_InstitucionID
										AND 	NumCtaInstit	= Par_NumCtaInstit),Cadena_Vacia);

		IF(IFNULL(Var_CtaInstitu,Cadena_Vacia) = Cadena_Vacia )THEN
			SET	Par_NumErr 		:= 2;
			SET	Par_ErrMen		:= 'La Cuenta Bancaria especificada no Existe';
            SET Var_Control		:= 'numCtaInstit';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_SpeiHab <> Est_SpeiHab ) THEN

			SET Aud_FechaActual := CURRENT_TIMESTAMP();
			

			
			# SE INSERTAN LAS AMORTIZACIONES
			SET @Cont		:= Entero_Cero;
			INSERT INTO TMPDISPERSIONAPOR(
				TransaccionID,			AportacionID,				AmortizacionID,			CuentaTranID,				InstitucionID,
				TipoCuentaSpei,			Clabe,						Beneficiario,			EsPrincipal,				MontoDispersion,
				NumReg,					EmpresaID,					Usuario,				FechaActual,				DireccionIP,
				ProgramaID,				Sucursal,					NumTransaccion,			AportBeneficiarioID)
			SELECT
				Aud_NumTransaccion,		HB.AportacionID,			HB.AmortizacionID,		HB.CuentaTranID,			HB.InstitucionID,
				HB.TipoCuentaSpei,		HB.Clabe,					HB.Beneficiario,		HB.EsPrincipal,			HB.MontoDispersion,
				@Cont:= @Cont +1,		Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion,		HB.HisBenefID
				FROM   SPEIAPORTACIONES SA
				INNER JOIN HISAPORTBENEFICIARIOS HB ON SA.AportBeneficiarioID = HB.HisBenefID 
				INNER JOIN SPEIENVIOS SE ON SA.FolioSpeiID = SE.FolioSpeiID
						WHERE SE.Estatus = 'P'
						AND HB.ClaveDispMov IS NULL;

			UPDATE SPEIAPORTACIONES SA INNER JOIN SPEIENVIOS SE ON SA.FolioSpeiID = SE.FolioSpeiID 
				   SET  SA.Estatus = 'D'
				   WHERE SE.Estatus != 'P';

			SET VarNumSpeiCan = (SELECT COUNT(*)
										FROM SPEIAPORTACIONES  WHERE Estatus = 'P');
            SET Aux_Spei = Entero_Cero;
                WHILE VarNumSpeiCan > Entero_Cero  DO
					
					SELECT FolioSpeiID, ClaveRastreo , CuentaAhoID, MontoAportacion
						INTO Var_Folio, Var_ClaveR, Var_CuentaAhoID, Var_MontoCargoDisp
					FROM SPEIAPORTACIONES WHERE Estatus = 'P' LIMIT  Aux_Spei,1;
                    CALL SPEIENVIOSCAN(Var_Folio,			Var_ClaveR,				 Var_Descripcion,	SalidaNo,			Par_NumErr,
									   Par_ErrMen,			Par_EmpresaID,      	 Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    
									   Aud_ProgramaID,     	Aud_Sucursal,       	 Aud_NumTransaccion);
					IF(Par_NumErr != Entero_Cero)THEN
						SET Par_ErrMen := CONCAT(Par_ErrMen,'<br>SPEIENVIOSCAN');
						LEAVE ManejoErrores;
					END IF;
			-- se obtiene el numero de creditos que cumplen la condicion
					CALL BLOQUEOSPRO(
						Entero_Cero,    	Mov_Bloqueo,  			Var_CuentaAhoID,  	    Var_FechaSistema,        	Var_MontoCargoDisp,
						Fecha_Vacia,    	Var_TipoBloqueo,    	Var_DescripBloqueo,     Aud_NumTransaccion,         Cadena_Vacia,
						Cadena_Vacia,   	Var_No,       		  	Par_NumErr, 			Par_ErrMen,			 		Par_EmpresaID,
						Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,    	Aud_ProgramaID,   		 	Aud_Sucursal,
						Aud_NumTransaccion);
					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				UPDATE SPEIAPORTACIONES 
					SET Estatus = 'D' 
				WHERE FolioSpeiID = Var_Folio;
				SET VarNumSpeiCan = (SELECT COUNT(*)
										FROM SPEIAPORTACIONES  WHERE Estatus = 'P');
                END WHILE;
        END IF;
		SET Var_NumAportaciones := (SELECT COUNT(*)
											FROM TMPDISPERSIONAPOR  TMP 
												INNER JOIN HISAPORTBENEFICIARIOS HPB ON TMP.AportBeneficiarioID = HPB.HisBenefID 
											WHERE HPB.ClaveDispMov is NULL);
		SET Var_NumAportaciones 	:= IFNULL(Var_NumAportaciones, Entero_Cero);

			IF(Var_NumAportaciones = Entero_Cero)THEN
				SET	Par_NumErr 		:= 1;
				SET	Par_ErrMen		:= 'No Hay Aportaciones para Importar';
	            SET Var_Control		:= 'folioOperacion';
	            SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		

                        
                
				
		
                    

		# SE INSERTA LA DISPERSION
		IF (Var_NumAportaciones > Entero_Cero) THEN

			CALL DISPERSIONALT(
				Fecha,				Var_Institucion,    Var_CtaInstitu,     Par_NumCtaInstit,	SalidaNo,
				Par_NumErr, 		Par_ErrMen,         FolioOperac,        Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				SET Par_ErrMen := CONCAT(Par_ErrMen,'<br>DISPERSIONALT');
				LEAVE ManejoErrores;
			END IF;

		END IF;
	
		SET Var_Reg	:= 0;
		
        WHILE( Var_NumAportaciones > Entero_Cero) DO
			
		
			SELECT
				TMP.AportacionID,		TMP.AmortizacionID,			TMP.CuentaTranID,	TMP.TransaccionID, TMP.AportBeneficiarioID
				INTO
				Var_AportacionID,	Var_AmortizacionID,		Var_CuentaTranID, Var_TransaccionID, Var_AportBenef
			FROM 	TMPDISPERSIONAPOR  TMP INNER JOIN HISAPORTBENEFICIARIOS HPB ON TMP.AportBeneficiarioID = HPB.HisBenefID  
			WHERE 
				TMP.ClaveDispMov IS NULL
				LIMIT Var_Reg,1;
			
			IF EXISTS(SELECT AportacionID FROM HISAPORTBENEFICIARIOS
						WHERE HisBenefID = Var_AportBenef )THEN

				SELECT 
					CT.Clabe,		AB.MontoDispersion,		AB.Beneficiario, CuentaAhoID
					INTO
					VarCuentaCLABE,	Var_MontoAporta,		Var_NomCliente, Var_CuentaAhoID
					FROM HISAPORTBENEFICIARIOS AB
						INNER JOIN APORTACIONES AP ON AB.AportacionID = AP.AportacionID
						INNER JOIN CUENTASTRANSFER CT ON AP.ClienteID = CT.ClienteID AND AB.CuentaTranID = CT.CuentaTranID
					WHERE
						AB.HisBenefID = Var_AportBenef;
                    
   

					

				IF IFNULL(Var_CuentaAhoID,Entero_Cero) > Entero_Cero THEN
					SET FechaSis := (SELECT
									DATE_FORMAT(FechaSistema,'%Y-%m-01')
									FROM PARAMETROSSIS);

					IF (YEAR(Par_Fecha) <= YEAR(FechaSis))THEN
						IF (MONTH(Par_Fecha) < MONTH(FechaSis))THEN
							SET	Par_NumErr 		:= 3;
							SET	Par_ErrMen		:= 'El Mes no Puede ser Menor al del Sistema';
							SET Var_Control		:= 'fechaActual';
							SET Var_Consecutivo := Entero_Cero;
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				IF(VarTipoPerson = PerFisica )THEN
					SET VarRFCcte := VarRFCcte;
				  ELSEIF(VarTipoPerson = PerMoral )THEN
					SET VarRFCcte := VarRFCPMcte;
				END IF;

				# Dispersion por SPEI
                SET Var_TipoDispersion ='S';
                
				IF(Var_TipoDispersion = TipoDisperSPEI) THEN
					SET Var_FormaPago	:=	FormaPagoSPEI;
					SET TipoMovDis		:=	TipoMovDisSPEI;
					SET Descrip			:=	DescripSPEI;
					SET VarTipoChequera := '';
				END IF;

				SET Var_NumSucursal := Aud_Sucursal;

				CALL DISPERSIONMOVALT(
					FolioOperac,		Var_CuentaAhoID,	Cadena_Vacia,		Descrip,			CONCAT('APORTACION ',CONVERT(Var_AportacionID,CHAR),'-',Var_AmortizacionID,'-',Var_CuentaTranID),
					TipoMovDis,			Var_FormaPago,		Var_MontoAporta,  	VarCuentaCLABE, 	Var_NomCliente,
					Fecha, 				VarRFCcte,			EstatusPendien, 	SalidaNo,			Var_NumSucursal,
					Var_Credito,		Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,
					Entero_Cero,		Cadena_Vacia,		VarTipoChequera,	Par_NumErr,			Par_ErrMen,
					RegistroSalida,		Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Var_TransaccionID);
				
				IF(Par_NumErr != Entero_Cero)THEN
					SET Par_ErrMen := CONCAT(Par_ErrMen,'<br>DISPERSIONMOVALT<br>');
					LEAVE ManejoErrores;
				END IF;
				
							
				# SE ACTUALIZA LA APORTACION
				UPDATE HISAPORTBENEFICIARIOS SET
					ClaveDispMov	= RegistroSalida
					WHERE HisBenefID = Var_AportBenef;
				UPDATE TMPDISPERSIONAPOR 
                SET ClaveDispMov = RegistroSalida
                WHERE AportBeneficiarioID = Var_AportBenef;
            
            	SET Var_NumAportaciones		:= (SELECT COUNT(*) FROM 	TMPDISPERSIONAPOR  TMP INNER JOIN HISAPORTBENEFICIARIOS HPB ON TMP.AportBeneficiarioID = HPB.HisBenefID  WHERE HPB.ClaveDispMov is NULL);
				SET Var_NumAportaciones 	:= IFNULL(Var_NumAportaciones, Entero_Cero);
			END IF;

					SET Var_AportacionID := Entero_Cero;
					SET	Var_AmortizacionID := Entero_Cero;
					SET Var_CuentaTranID := Entero_Cero;
					SET Var_TransaccionID := Entero_Cero;
					SET Var_AportBenef	:= Entero_Cero;
					SET VarCuentaCLABE := Cadena_Vacia;
					SET Var_MontoAporta := Decimal_Cero;
					SET	Var_NomCliente := Cadena_Vacia;
					SET Var_CuentaAhoID := Entero_Cero;

				SET Var_Reg := Entero_Cero;
		END WHILE;

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	

			
        SET Par_NumErr		:= 0;
		SET Par_ErrMen 		:= CONCAT('Dispersion agregada: ',CONVERT(FolioOperac,CHAR(10)));
        SET Var_Control		:= 'folioOperacion';
		SET Var_Consecutivo := FolioOperac;

	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;


END TerminaStore$$