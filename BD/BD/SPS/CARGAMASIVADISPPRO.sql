-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGAMASIVADISPPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGAMASIVADISPPRO`;
DELIMITER $$

CREATE PROCEDURE `CARGAMASIVADISPPRO`(
	Par_Salida 				CHAR(1),
    INOUT	Par_NumErr	 	INT(11),
    INOUT	Par_ErrMen	 	VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_FolDisper		INT(11);
	DECLARE Var_FechaSis 		DATE;
	DECLARE Var_InstitucionID	INT(11);
	DECLARE Var_CtaInstitu		VARCHAR(20);
	DECLARE Var_NumCtaInstit	VARCHAR(20);
	DECLARE Var_Fecha 			DATE;

	DECLARE Var_TipoCuenta 		INT(11); 		-- Tipo de cuenta 1= Cuenta contable	2= Cuenta de Ahorro 3= Crédito
	DECLARE Var_CuentaCargo 	VARCHAR(50); 	-- Cuenta de ahorro o cuenta contable
	DECLARE Var_Descripcion 	VARCHAR(50); 	-- Descripción del movimiento
	DECLARE Var_Referencia 		VARCHAR(50); 	-- Referencia del movimiento
	DECLARE Var_ReferenciaBlo 		VARCHAR(50); 	-- Referencia del movimiento Bloqueo
	DECLARE Var_FormaPago 		CHAR(1); 		-- Forma de Pago S=SPEI C=Cheque O=Orden de Pago A=Transferencia Santander
	DECLARE Var_CtaBenefi	 	VARCHAR(50); 	-- Cuenta a la que se realizará el pago.
	DECLARE Var_Monto 			DECIMAL(14,2); 	-- Monto a dispersar
	DECLARE Var_NombreBenefi 	VARCHAR(250); 	-- Nombre del Beneficiario
	DECLARE Var_RFC 			VARCHAR(13); 	-- RFC del beneficiario
	DECLARE Var_Contador		INT(11);		-- Contador para el ciclo WHILE
	DECLARE Var_Longitud		INT(11);		-- Longitud para ser recorridos
	DECLARE Var_SiHabilita		CHAR(1);
	DECLARE Var_DispersionSan 	CHAR(1);			-- Genera Dispersion Automatica
	DECLARE Fecha				DATE;
	DECLARE Var_EsAutomatico	CHAR(1);			-- requiere generar la referencia automantica
	DECLARE Var_Vigencia		INT(11);
	DECLARE Var_Credito			BIGINT(12);
	DECLARE Var_RefAutomatico	VARCHAR(20);		-- Referencia Automatica
	DECLARE Descrip            	VARCHAR(40);
	DECLARE TipoMovDis			CHAR(4);
	DECLARE RegistroSalida		INT(11);
	DECLARE VarCuentaCLABE		VARCHAR(20);
	DECLARE Var_CuentaCred		BIGINT(12);
	DECLARE Var_CuentaDisp		VARCHAR(50); 	-- Cuenta de ahorro o contable de donde se realizara la dispersion
	DECLARE Var_Complemento		VARCHAR(18);
	DECLARE Var_FechaVen 		DATE;
	DECLARE Var_EsHabil			CHAR(1);
	DECLARE Var_TipoChequera	CHAR(1);
	DECLARE Var_Chequera 		CHAR(1);
	DECLARE Var_FolioCredito	INT(11);
	DECLARE Var_TipoRefere		INT(11);
	DECLARE Var_ClienteID		INT(11);

	-- Declaracion de Constantes
	DECLARE Salida_SI			CHAR(1);
	DECLARE Salida_NO			CHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;

	DECLARE Con_Contable		INT(11);		-- Tipo de cuenta
	DECLARE Con_Ahorro			INT(11);		-- Tipo de cuenta
	DECLARE Con_Credito			INT(11);		-- Tipo de cuenta

	DECLARE Con_SPEI			CHAR(1);		-- Forma de Pago
	DECLARE Con_Cheque			CHAR(1);		-- Forma de Pago
	DECLARE Con_Orden			CHAR(1);		-- Forma de Pago
	DECLARE Con_Transfer		CHAR(1);		-- Forma de Pago
	DECLARE Con_DispTransSanta	VARCHAR(50);		-- Llave parametro para el tipo de movimiento contable de Transferecnias Santander
	DECLARE ValorParam			VARCHAR(100);
	DECLARE DispersionSantander VARCHAR(50);		-- Llave Parametros Para dipersion Santander
	DECLARE SiHabilita 			CHAR(1);
	DECLARE DescripRefSantan	VARCHAR(40);
	DECLARE FormaPagoSPEI      	INT(11);
	DECLARE FormaPagoCheque	   	INT(11);
	DECLARE FormaPagoOrden	   	INT(11);
	DECLARE FormaPagoSantan		INT(11);
	DECLARE TipoMovDisOrden		CHAR(4);
	DECLARE TipoMovDisSantan	CHAR(4);
	DECLARE DescripSPEI        	VARCHAR(40);
	DECLARE DescripCheq		   	VARCHAR(40);
	DECLARE DescripOrdenPago	VARCHAR(50);
	DECLARE Con_SI 				CHAR(1);
	DECLARE Con_Automatico 		CHAR(1);
	DECLARE Aut_Credito 		INT(11);
	DECLARE Aut_Cuenta			INT(11);
	DECLARE EstatusPendien	   	CHAR(1);
	DECLARE Con_Bloqueo			CHAR(1);
	DECLARE TipoBloqueo			INT(11);
	DECLARE DesBloqueo 			VARCHAR(25);
	DECLARE Tipo_ChequeIndividual 	CHAR(4);
	DECLARE Tipo_SpeiIndividual 	CHAR(4);
	DECLARE Con_TipoCredito		INT(11);
	DECLARE Con_Proforma		CHAR(1);
	DECLARE Con_Estandar		CHAR(1);
	DECLARE Con_Ambas			CHAR(1);
	DECLARE Con_Otro			INT(11);		-- Tipo de dispersion Otro
	DECLARE Con_Creditos		INT(11);		-- Tipo de dispersion Credito
	DECLARE Con_Cuenta			INT(11);		-- Tipo de dispersion Cuenta




	-- Seteo de valores
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Aud_FechaActual 	:= NOW();

	SET Con_Contable		:= 1;
	SET Con_Ahorro			:= 2;
	SET Con_Credito			:= 3;
	SET Con_Otro			:= 2;
	SET Con_Creditos		:= 1;
	SET Con_Cuenta			:= 3;

	SET Con_SPEI			:= 'S';
	SET Con_Cheque			:= 'C';
	SET Con_Orden			:= 'O';
	SET Con_Transfer		:= 'A';
	SET Con_DispTransSanta	:= 'DispTransSantander';
	SET ValorParam			:= "HabilitaFechaDisp";
	SET DispersionSantander	:= 'DispersionSantander';				-- Llave Parametros Para dipersion Santander
	SET SiHabilita 			:= 'S';
	SET DescripOrdenPago	:= 'ORDEN PAGO DESEMBOLSO CREDITO';
	SET DescripRefSantan	:= 'TRAN. SANTAN DESEMBOLSO DE CREDITO';
	SET FormaPagoSPEI       := 1;
	SET FormaPagoCheque     := 2;
	SET FormaPagoOrden		:= 5;
	SET FormaPagoSantan		:= 6;
	SET TipoMovDisOrden     := '700';
	SET Tipo_ChequeIndividual		:= '4';
	SET Tipo_SpeiIndividual			:= '3';
	SET DescripSPEI         := 'SPEI DESEMBOLSO CREDITO';
	SET DescripCheq         := 'CHEQUE PAGADO DES CREDITO';
	SET Con_SI 				:= 'S';
	SET Con_Automatico		:= 'A';
	SET Aut_Credito			:= 1;
	SET Aut_Cuenta			:= 2;
	SET EstatusPendien      := 'P';
	SET Con_Bloqueo			:= 'B';
	SET TipoBloqueo			:= 1;
	SET DesBloqueo 			:= 'BLOQUEO POR DISPERSION';
	SET Con_TipoCredito		:= 71;
	SET Con_Proforma		:= 'P';
	SET Con_Estandar		:= 'E';
	SET Con_Ambas			:= 'A';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
   		BEGIN
        	SET Par_NumErr = 999;
        	SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-CARGAMASIVADISPPRO');
        	SET Var_Control  := 'SQLEXCEPTION';
    	END;



		SELECT FechaSistema  INTO Var_FechaSis FROM PARAMETROSSIS;

		SELECT InstitucionID, CuentaAhoID, NumCtaInstit,FechaOperacion
		INTO Var_InstitucionID, Var_CtaInstitu, Var_NumCtaInstit,Var_Fecha
		FROM CARGAMASIVADISP
		WHERE NumTransaccion = Aud_NumTransaccion;

		SELECT 	teso.TipoChequera
		INTO 	Var_Chequera
		FROM CUENTASAHOTESO teso
		INNER JOIN CUENTASAHO aho ON teso.CuentaAhoID = aho.CuentaAhoID
		WHERE teso.InstitucionID= Var_InstitucionID
		AND teso.NumCtaInstit= Var_NumCtaInstit;


		SELECT ValorParametro INTO TipoMovDisSantan
		FROM PARAMGENERALES
		WHERE LlaveParametro=Con_DispTransSanta;

    	SET TipoMovDisSantan := IFNULL(TipoMovDisSantan, Cadena_Vacia);

    	SELECT ValorParametro INTO Var_SiHabilita
			FROM PARAMGENERALES WHERE LlaveParametro=ValorParam;

		SELECT ValorParametro INTO Var_DispersionSan
			FROM PARAMGENERALES WHERE LlaveParametro=DispersionSantander;

		IF Var_SiHabilita=SiHabilita THEN
			SET Fecha :=Var_Fecha;
		ELSE
			SET Fecha :=Var_FechaSis;
		END IF;

		SELECT C.AlgClaveRetiro, C.VigClaveRetiro INTO Var_EsAutomatico, Var_Vigencia
		FROM CUENTASAHOTESO C
		WHERE C.InstitucionID		= Var_InstitucionID
			AND	C.NumCtaInstit		= Var_NumCtaInstit;


		CALL DISPERSIONALT(
		Fecha,		Var_InstitucionID,  Var_CtaInstitu,     Var_NumCtaInstit,	Salida_NO,
	    Par_NumErr, 		Par_ErrMen,			Var_FolDisper,      Par_EmpresaID,      Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF Par_Salida != Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(MAX(Consecutivo),Entero_Cero) INTO Var_Longitud FROM TMPCARGAMASIVADISP
		WHERE NumTransaccion = Aud_NumTransaccion;

		SET Var_Contador := 1;

		WHILE (Var_Contador <= Var_Longitud) DO

			SELECT 	TipoCuenta,		REPLACE(CuentaCargo,'.0',Cadena_Vacia),	Descripcion,
					REPLACE(Referencia,'.0',Cadena_Vacia), FormaPago,
					REPLACE(CtaBenefi,'.0',Cadena_Vacia),		Monto,			NombreBenefi,	RFC
			INTO 	Var_TipoCuenta,		Var_CuentaCargo,	Var_Descripcion,
					Var_Referencia, Var_FormaPago,
					Var_CtaBenefi,		Var_Monto,			Var_NombreBenefi,	Var_RFC
			FROM  TMPCARGAMASIVADISP
			WHERE Consecutivo = Var_Contador AND NumTransaccion = Aud_NumTransaccion;

			SET Var_ReferenciaBlo := Aud_NumTransaccion;
			SET Var_CuentaCargo := TRIM(REPLACE(REPLACE(Var_CuentaCargo,'.',''),' ',''));

			IF Var_TipoCuenta = Con_Credito OR Var_TipoCuenta = Con_Ahorro THEN

				IF Var_TipoCuenta = Con_Credito THEN
					SELECT CuentaID
					INTO Var_CuentaCred
					FROM CREDITOS
					WHERE CreditoID = Var_CuentaCargo;

					SET Var_Credito := Var_CuentaCargo;
					SET Var_CuentaDisp := Var_CuentaCred;
					SET Var_TipoRefere := Aut_Credito;
				ELSE
					SET Var_CuentaDisp := Var_CuentaCargo;
					SET Var_TipoRefere := Aut_Cuenta;
				END IF;

				IF(Var_FormaPago = Con_SPEI) THEN
					SET Var_FormaPago	:=	FormaPagoSPEI;
					SET TipoMovDis		:=	Tipo_SpeiIndividual;
					SET Descrip			:=	DescripSPEI;
					SET VarCuentaCLABE	:= Var_CtaBenefi;
				END IF;

				IF(Var_FormaPago = Con_Cheque) THEN
					SET Var_FormaPago	:=	FormaPagoCheque;
					SET TipoMovDis		:=	Tipo_ChequeIndividual;
					SET Descrip			:=	DescripCheq;

					IF Var_Chequera = Con_Proforma THEN
						SET Var_TipoChequera := Con_Proforma;
						SET VarCuentaCLABE	:= Var_CtaBenefi;
					ELSEIF Var_Chequera = Con_Estandar THEN
						SET Var_TipoChequera := Con_Estandar;
						SET VarCuentaCLABE	:= Var_CtaBenefi;
					ELSE
						SET Var_TipoChequera := '';
						SET VarCuentaCLABE	:= '';
					END IF;
				END IF;

				IF(Var_FormaPago = Con_Orden) THEN
					SET Var_FormaPago	:=	FormaPagoOrden;
					SET TipoMovDis		:=	TipoMovDisOrden;
					SET Descrip			:=	DescripOrdenPago;
					SET VarCuentaCLABE	:= 	Var_CtaBenefi;
					SET Var_ReferenciaBlo := Var_CuentaCargo;
				END IF;

				IF(Var_FormaPago = Con_Transfer) THEN
					SET Var_FormaPago	:=	FormaPagoSantan;
					SET TipoMovDis		:=	TipoMovDisSantan;
					SET Descrip			:=	DescripRefSantan;
					SET VarCuentaCLABE	:= Var_CtaBenefi;
					SET Var_ReferenciaBlo := Var_CuentaCargo;
				END IF;

				IF Var_DispersionSan = Con_SI AND Var_EsAutomatico = Con_Automatico AND  Var_FormaPago	=	FormaPagoOrden THEN

						CALL GENERAREFAUTSAN(Var_TipoRefere,		Var_CuentaCargo,	Salida_NO,			Par_NumErr,			Par_ErrMen,
											Var_RefAutomatico, 		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

						IF Var_RefAutomatico != Cadena_Vacia THEN
							SET VarCuentaCLABE := Var_RefAutomatico;
						END IF;

				END IF;


			END IF;

			IF Var_TipoCuenta = Con_Contable THEN
				IF(Var_FormaPago = Con_SPEI) THEN
					SET Var_FormaPago	:=	FormaPagoSPEI;
					SET TipoMovDis		:=	Tipo_SpeiIndividual;
					SET Descrip			:=	Var_Descripcion;
					SET VarCuentaCLABE	:= Var_CtaBenefi;
				END IF;

				IF(Var_FormaPago = Con_Cheque) THEN
					SET Var_FormaPago	:=	FormaPagoCheque;
					SET TipoMovDis		:=	Tipo_ChequeIndividual;
					SET Descrip			:=	Var_Descripcion;

					IF Var_Chequera = Con_Proforma THEN

						SET Var_TipoChequera := Con_Proforma;
						SET VarCuentaCLABE	:= Var_CtaBenefi;

					ELSEIF Var_Chequera = Con_Estandar THEN

						SET Var_TipoChequera := Con_Estandar;
						SET VarCuentaCLABE	:= Var_CtaBenefi;

					ELSE

						SET Var_TipoChequera := '';
						SET VarCuentaCLABE	:= '';

					END IF;

				END IF;

				IF(Var_FormaPago = Con_Orden) THEN
					SET Var_FormaPago	:=	FormaPagoOrden;
					SET TipoMovDis		:=	TipoMovDisOrden;
					SET Descrip			:=	DescripOrdenPago;
					SET VarCuentaCLABE	:= Var_CtaBenefi;

				END IF;

				IF(Var_FormaPago = Con_Transfer) THEN
					SET Var_FormaPago	:=	FormaPagoSantan;
					SET TipoMovDis		:=	TipoMovDisSantan;
					SET Descrip			:=	DescripRefSantan;
					SET VarCuentaCLABE	:= Var_CtaBenefi;
				END IF;


				SET Var_CuentaDisp := Var_CuentaCargo;

			END IF;



			IF Var_TipoCuenta = Con_Ahorro OR Var_TipoCuenta = Con_Credito THEN


				CALL DISPERSIONMOVALT(	Var_FolDisper,			Var_CuentaDisp,    	Cadena_Vacia,		Descrip,	  	Var_Referencia,
										TipoMovDis, 			Var_FormaPago,		Var_Monto,      	VarCuentaCLABE, Var_NombreBenefi,
										Var_FechaSis, 			Var_RFC,			EstatusPendien, 	Salida_NO,      Aud_Sucursal,
										Var_Credito,			Entero_Cero,		Entero_Cero,		Entero_Cero,	Entero_Cero,
										Entero_Cero,			Cadena_Vacia,		Var_TipoChequera,	Par_NumErr,		Par_ErrMen,
										RegistroSalida, 		Par_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,
										Aud_ProgramaID, 		Aud_Sucursal,  		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				CALL BLOQUEOSPRO(Entero_Cero,	Con_Bloqueo,	Var_CuentaDisp,		Var_FechaSis,		Var_Monto,
							Fecha_Vacia,	TipoBloqueo,		DesBloqueo,			Var_ReferenciaBlo,	Cadena_Vacia,
							Cadena_Vacia,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
							Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


				IF Var_DispersionSan = Con_SI AND Var_EsAutomatico = Con_Automatico AND  Var_FormaPago	=	FormaPagoOrden THEN
					SET Var_FolioCredito := SUBSTRING(Var_RefAutomatico,1,1);
					IF (Var_FolioCredito = Con_Otro) THEN
						SET Var_Complemento := SUBSTRING(Var_RefAutomatico,20,1);
					END IF;
					IF(Var_FolioCredito = Con_Cuenta)THEN
						SET Var_Complemento := SUBSTRING(Var_RefAutomatico,14,1);
					END IF;
					IF(Var_FolioCredito = Con_Creditos)THEN
						SET Var_Complemento := SUBSTRING(Var_RefAutomatico,13,1);
					END IF;

					CALL DIASFESTIVOSCAL(
						Var_FechaSis,		Var_Vigencia,		Var_FechaVen,		Var_EsHabil,		Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					CALL REFORDENPAGOSANALT(
						Var_RefAutomatico,		Var_Complemento,		Var_FolDisper,		RegistroSalida,		Var_FechaSis,
						Var_FechaVen,			Var_FolioCredito,		Var_CuentaCargo,	Salida_NO,			Par_NumErr,
						Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF Var_TipoCuenta = Con_Contable THEN

				CALL DISPERSIONMOVALT(	Var_FolDisper,			Entero_Cero,    	Var_CuentaCargo,		Descrip,	  	Var_Referencia,
					    				TipoMovDis, 			Var_FormaPago,		Var_Monto,      		VarCuentaCLABE, Var_NombreBenefi,
										Var_FechaSis, 			Var_RFC,			EstatusPendien, 		Salida_NO,      Aud_Sucursal,
										Var_Credito,			Entero_Cero,		Entero_Cero,			Entero_Cero,	Entero_Cero,
										Entero_Cero,			Cadena_Vacia,		Var_TipoChequera,		Par_NumErr,		Par_ErrMen,
										RegistroSalida,    		Par_EmpresaID,  	Aud_Usuario,			Aud_FechaActual,Aud_DireccionIP,
										Aud_ProgramaID,    		Aud_Sucursal,  		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;


			-- Cuando son de tipo transferencia santander se da de alta para el archivo de afiliacion
			IF Var_FormaPago	=	FormaPagoSantan THEN

				CALL CUENTASSANTANDERALT(Entero_Cero,			Var_ClienteID,			Cadena_Vacia,		Cadena_Vacia,		Var_CtaBenefi,
										Var_NombreBenefi,		Cadena_Vacia,			Entero_Cero,		Entero_Cero,		Cadena_Vacia,
										Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,
										Cadena_Vacia,			Cadena_Vacia,			Var_FechaSis,		Salida_NO,			Par_NumErr,
										Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);


				IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
				END IF;

			END IF;

			SET Var_Contador := Var_Contador+1;

		END WHILE;


    	SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Proceso Realizado Exitosamente <br/> Folio de Dispersi&oacute;n : ',Var_FolDisper);
		SET Var_Control := 'institucionID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Entero_Cero AS Consecutivo;
	END IF;


END TerminaStore$$