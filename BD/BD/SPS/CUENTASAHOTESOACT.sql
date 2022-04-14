-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOTESOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOTESOACT`;
DELIMITER $$


CREATE PROCEDURE `CUENTASAHOTESOACT`(
# ===========================================================
# ------------SP PARA ACTUALIZAR CUENTAS BANCARIAS-----------
# ===========================================================
	Par_SucursalInstit		VARCHAR(50),		-- Descripcion de la Sucursal
	Par_Chequera			CHAR(1),			-- Requiere chequera S.- Si N.- No
	Par_CentroCostoID		INT(11),			-- Numero del Centro de Costos
	Par_CuentaCompletaID	CHAR(25),			-- Numero de la cuenta contable
	Par_Principal			CHAR(1),			-- Es principal S.- Si N.- No

	Par_InstitucionID		INT(11),			-- Numero de la institucion bancaria
	Par_NumCtaInstit		VARCHAR(20),		-- Numero de la cuenta bancaria
	Par_CuentaAhoID			BIGINT(12),			-- Numero de cuenta de ahorro
	Par_FolioUtilizar		BIGINT(20),			-- Numero de Folio a Utilizar
	Par_RutaCheque			CHAR(100),			-- Formato de Impresion de Cheque (Nombre archivo prpt)

	Par_SobregirarSaldo		CHAR(1),			-- Permirte sobregirar el saldo de la cuenta S.- Si N.- No
	Par_TipoChequera		CHAR(2),			--
	Par_FolioUtilizarEstan 	BIGINT(20),			-- Numero de Folio de Cheque formato estandar a Utilizar
	Par_RutaChequeEstan	 	VARCHAR(100),		-- Formato de Impresion de Cheque formato estandar(Nombre archivo prpt)

    Par_NumConvenio	 		VARCHAR(30),		-- Numero de convenio
    Par_DescConvenio	 	VARCHAR(100),		-- Descripcion del convenio
    Par_ProtecOrdenPago	 	CHAR(1),			-- Proteccion de ordenes de pago
 	Par_AlgClaveRetiro		CHAR(1),			-- Indica si la generacion del la referencia de orden de pago sera Manual(M o Automatico(A)
    Par_VigClaveRetiro		INT(1),				-- Indica los dias de vigencia de la referencia de orden de pago

	Par_TipoActualiza		TINYINT UNSIGNED,	-- Numero de Actualizacion
	Par_Salida				CHAR(1),			-- Parametro de Salida S.- Si N.- No
	INOUT	Par_NumErr		INT(11),			-- Numero de Error
	INOUT	Par_ErrMen		VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(20),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE	Var_CuentaAhoID		BIGINT(12);
	DECLARE	Var_NumCtaInstit	VARCHAR(20);
	DECLARE	Var_CuentaCompleta	CHAR(25);
	DECLARE Var_FechaCorte		DATE;
	DECLARE	Var_SaldoFinal		DECIMAL(14,4);
	DECLARE VarControl 			VARCHAR(100);
	DECLARE	Var_Consecutivo		BIGINT(12);
	DECLARE FechaSistema		VARCHAR(12);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
    DECLARE Decimal_Cero		DECIMAL(12,2);
    DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE	Estatus_Apert		CHAR(1);
	DECLARE	Var_Principal		CHAR(1);
	DECLARE	Var_NoPcpal			CHAR(1);
	DECLARE Var_Deudora			CHAR(1);
	DECLARE Var_ChequeraSi		CHAR(1);
	DECLARE TipCheq_Proforma	CHAR(1);
    DECLARE TipCheq_Estandar	CHAR(1);
    DECLARE TipCheq_Ambas		CHAR(1);
	DECLARE	Act_General			INT(11);
	DECLARE	Act_FolioCheque		INT(11);
	DECLARE Entero_Siete		INT(11);
	DECLARE Con_Manual			CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';			-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';-- Fecha vacia
	SET Entero_Cero				:= 0;			-- Entero Cero
    SET Decimal_Cero			:= 0.0;			-- DECIMAL Cero
    SET SalidaSI				:= 'S';
	SET SalidaNO				:= 'N';
	SET Estatus_Apert			:= 'A';			-- Estatus Activo de apertura
	SET Var_Principal 			:= 'S';			-- Cuenta principal Si
	SET Var_NoPcpal   			:= 'N';			-- Cuenta principal No
	SET Var_Deudora 			:= 'D';			-- Tipo de Naturaleza Deudora
	SET Var_ChequeraSi			:= 'S';			-- Si cuenta con chequera
	SET TipCheq_Proforma		:= 'P';			-- Tipo chequera proforma
    SET TipCheq_Estandar		:= 'E';			-- Tipo chequera estandar
    SET TipCheq_Ambas			:= 'A';			-- Tipo Chequera Ambas
	SET Act_General				:= 1;			-- Tipo de actualzacion General a la tabla, CUENTASAHOTESO, funcionalidad que ya existia
	SET Act_FolioCheque			:= 2;			-- Tipo de actualizacion para Modificar solo El folio de cheque proforma utilizado
	SET Aud_FechaActual 		:= NOW();
	SET Entero_Siete			:= 7;
	SET Con_Manual				:= 'M';			-- Generacion de Referencia Manual

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASAHOTESOACT');
				SET VarControl = 'SQLEXCEPTION';
			END;

		-- 1.- Tipo de actualzacion General a la tabla CUENTASAHOTESO
		IF (Par_TipoActualiza = Act_General) THEN

			IF(IFNULL(Par_SucursalInstit, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr      := 003;
				SET Par_ErrMen      := 'La sucursal esta vacia.';
				SET VarControl		:= 'sucursalInstit';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Chequera, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr      := 006;
				SET Par_ErrMen      := 'No ha seleccionado si requiere de chequera.';
				SET VarControl		:= 'chequera';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CentroCostoID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr      := 008;
				SET Par_ErrMen      := 'El centro de costos esta vacia.';
				SET VarControl		:= 'centroCostoID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CuentaCompletaID, Cadena_Vacia)) != Cadena_Vacia THEN
				-- valida la Cuenta Constable EspecIFicada
				CALL CUENTASCONTABLESVAL(	Par_CuentaCompletaID,	SalidaNO,		Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
											Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
											Aud_NumTransaccion);
				-- Validamos la respuesta
				IF(Par_NumErr <> Entero_Cero) THEN
					SET Par_NumErr := 007;
					SET VarControl:= 'cuentaCompletaID';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;


			SET Aud_FechaActual := CURRENT_TIMESTAMP();

			SELECT		CuentaCompletaID INTO Var_CuentaCompleta
				FROM 	CUENTASAHOTESO
				WHERE	InstitucionID	= Par_InstitucionID
				AND 	NumCtaInstit 	= Par_NumCtaInstit;

			IF(Par_CuentaCompletaID <> Var_CuentaCompleta)THEN
				SET FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS);
				SET Var_FechaCorte	:= (SELECT IFNULL(MAX(FechaCorte),FechaSistema) FROM SALDOSCONTABLES);

				SELECT	CASE WHEN 	Tmp.Naturaleza = Var_Deudora THEN
						IFNULL((IFNULL(Tmp.Cargos, Entero_Cero)+IFNULL(SUM(Sal.SaldoFinal), Entero_Cero))- IFNULL(Tmp.Abonos, Entero_Cero),Entero_Cero)
					ELSE IFNULL((IFNULL(Tmp.Abonos, Entero_Cero)+IFNULL(SUM(Sal.SaldoFinal), Entero_Cero))- IFNULL(Tmp.Cargos, Entero_Cero), Entero_Cero)
					END AS SaldoFinal INTO Var_SaldoFinal
					FROM CUENTASCONTABLES Cue
					LEFT OUTER JOIN (SELECT	Sal.CuentaCompleta AS CuentaContable,	SUM(Pol.Cargos) AS Cargos,	SUM(Pol.Abonos) AS Abonos,
											MAX(Sal.Naturaleza) AS Naturaleza
										FROM 	DETALLEPOLIZA Pol,
												CUENTASCONTABLES Sal
										WHERE 	Pol.CuentaCompleta	=	Sal.CuentaCompleta
										GROUP BY Pol.CuentaCompleta) AS Tmp ON Cue.CuentaCompleta = Tmp.CuentaContable
					LEFT OUTER JOIN SALDOSCONTABLES AS Sal ON (Cue.CuentaCompleta = Sal.CuentaCompleta
					AND 	Sal.FechaCorte 		= Var_FechaCorte )
					WHERE 	Cue.CuentaCompleta  = Var_CuentaCompleta
					GROUP BY Cue.CuentaCompleta;

				IF(Var_SaldoFinal != Decimal_Cero)THEN
					SET Par_NumErr      := 009;
					SET Par_ErrMen      := 'La Cuenta Contable tiene Saldo.';
					SET VarControl		:= 'cuentaCompletaID';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_Chequera = Var_ChequeraSi) THEN

				IF(IFNULL(Par_TipoChequera, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr      := 010;
					SET Par_ErrMen      := 'El tipo de Chequera esta Vacia.';
					SET VarControl		:= 'tipoChequera';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				IF(Par_TipoChequera = TipCheq_Proforma)THEN
					IF(Par_FolioUtilizar = Entero_Cero)THEN
						SET Par_NumErr      := 010;
						SET Par_ErrMen      := 'El Ultimo Folio a Utilizar de chequera proforma esta Vacio.';
						SET VarControl		:= 'folioUtilizar';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;

					SET Par_RutaCheque 	:= IFNULL(Par_RutaCheque,Cadena_Vacia);

					IF(Par_RutaCheque = Cadena_Vacia)THEN
						SET Par_NumErr      := 011;
						SET Par_ErrMen      := 'El Formato de Impresion de Cheque proforma esta Vacio';
						SET VarControl		:= 'rutaCheque';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;

				ELSEIF(Par_TipoChequera = TipCheq_Estandar)THEN
					IF(Par_FolioUtilizarEstan = Entero_Cero)THEN
						SET Par_NumErr      := 012;
						SET Par_ErrMen      := 'El Ultimo Folio a Utilizar de chequera estandar esta Vacio.';
						SET VarControl		:= 'folioUtilizarEStan';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;

					SET Par_RutaChequeEstan 	:= IFNULL(Par_RutaChequeEstan,Cadena_Vacia);
					IF(Par_RutaChequeEstan = Cadena_Vacia)THEN
						SET Par_NumErr      := 013;
						SET Par_ErrMen      := 'El Formato de Impresion de Cheque estandar esta Vacio';
						SET VarControl		:= 'rutaChequeEstan';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;
				ELSEIF (Par_TipoChequera = TipCheq_Ambas)THEN
					IF(Par_FolioUtilizar = Entero_Cero)THEN
						SET Par_NumErr      := 010;
						SET Par_ErrMen      := 'El Ultimo Folio a Utilizar de chequera proforma esta Vacio.';
						SET VarControl		:= 'folioUtilizar';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;

					SET Par_RutaCheque 	:= IFNULL(Par_RutaCheque,Cadena_Vacia);

					IF(Par_RutaCheque = Cadena_Vacia)THEN
						SET Par_NumErr      := 011;
						SET Par_ErrMen      := 'El Formato de Impresion de Cheque proforma esta Vacio';
						SET VarControl		:= 'rutaCheque';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;

					IF(Par_FolioUtilizarEstan = Entero_Cero)THEN
						SET Par_NumErr      := 012;
						SET Par_ErrMen      := 'El Ultimo Folio a Utilizar de chequera estandar esta Vacio.';
						SET VarControl		:= 'folioUtilizarEStan';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;

					SET Par_RutaChequeEstan 	:= IFNULL(Par_RutaChequeEstan,Cadena_Vacia);
					IF(Par_RutaChequeEstan = Cadena_Vacia)THEN
						SET Par_NumErr      := 013;
						SET Par_ErrMen      := 'El Formato de Impresion de Cheque estandar esta Vacio';
						SET VarControl		:= 'rutaChequeEstan';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;


			IF(Par_Principal = Var_Principal)THEN

				SELECT 		CuentaAhoID,		NumCtaInstit
					INTO 	Var_CuentaAhoID,	Var_NumCtaInstit
					FROM 	CUENTASAHOTESO
					WHERE 	InstitucionID	= Par_InstitucionID
					AND 	Principal		= Var_Principal;

				IF(Par_CuentaAhoID  <> Var_CuentaAhoID AND Par_NumCtaInstit <> Var_NumCtaInstit)THEN

					UPDATE CUENTASAHOTESO SET
								Principal 		= Var_NoPcpal,
								EmpresaID       = Aud_EmpresaID,
								Usuario         = Aud_Usuario,
								FechaActual     = Aud_FechaActual,
								DireccionIP     = Aud_DireccionIP,

								ProgramaID      = Aud_ProgramaID,
								Sucursal        = Aud_Sucursal,
								NumTransaccion  = Aud_NumTransaccion

						WHERE 	InstitucionID	= Par_InstitucionID
						AND 	CuentaAhoID		= Var_CuentaAhoID
						AND 	NumCtaInstit 	= Var_NumCtaInstit;
				END IF;
			END IF;

			IF(Par_Principal = Var_NoPcpal)THEN

				SELECT 		CuentaAhoID,		NumCtaInstit
					INTO 	Var_CuentaAhoID,	Var_NumCtaInstit
					FROM 	CUENTASAHOTESO
					WHERE 	InstitucionID	= Par_InstitucionID
					AND 	Principal		= Var_Principal
					LIMIT 	1;

				IF(Par_CuentaAhoID  = Var_CuentaAhoID AND Par_NumCtaInstit = Var_NumCtaInstit)THEN
					SET Par_NumErr      := 012;
					SET Par_ErrMen      := 'La Institucion no tiene una Cuenta Principal.';
					SET VarControl		:= 'checkPrincipal';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Par_VigClaveRetiro := IFNULL(Par_VigClaveRetiro,Entero_Cero);
			SET Par_AlgClaveRetiro := IFNULL(Par_AlgClaveRetiro,Cadena_Vacia);

			IF Par_AlgClaveRetiro = Cadena_Vacia THEN
				SET Par_AlgClaveRetiro := Con_Manual;
			END IF;

			IF Par_VigClaveRetiro = Entero_Cero THEN
				SET Par_VigClaveRetiro := Entero_Siete;
			END IF;


			UPDATE CUENTASAHOTESO SET
						SucursalInstit   	= Par_SucursalInstit,
						Chequera         	= Par_Chequera,
						CuentaCompletaID	= Par_CuentaCompletaID,
						CentroCostoID    	= Par_CentroCostoID,
						Estatus          	= Estatus_Apert,

						Principal			= Par_Principal,
						FolioUtilizar		= Par_FolioUtilizar,
						RutaCheque			= Par_RutaCheque,
						SobregirarSaldo 	= Par_SobregirarSaldo,
                        TipoChequera		= Par_TipoChequera,
                        FolioUtilizarEstan	= Par_FolioUtilizarEstan,
						RutaChequeEstan		= Par_RutaChequeEstan,
                        NumConvenio			= Par_NumConvenio,
                        DescConvenio		= Par_DescConvenio,
                        ProtecOrdenPago		= Par_ProtecOrdenPago,
                        AlgClaveRetiro 		= Par_AlgClaveRetiro,
    					VigClaveRetiro		= Par_VigClaveRetiro,

						EmpresaID     		= Aud_EmpresaID,
						Usuario       		= Aud_Usuario,
						FechaActual   		= Aud_FechaActual,
						DireccionIP   		= Aud_DireccionIP,
						ProgramaID    		= Aud_ProgramaID,
						Sucursal      		= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
				WHERE 	InstitucionID		= Par_InstitucionID
				AND		NumCtaInstit		= Par_NumCtaInstit;

			SET Par_NumErr		:= 000;
			SET Par_ErrMen		:= CONCAT('Cuenta Bancaria Modificada Exitosamente: ', CONVERT(Par_NumCtaInstit, CHAR));
			SET VarControl		:= 'numCtaInstit';
			SET Var_Consecutivo := Par_NumCtaInstit;

		END IF;


		-- 2.- Tipo de actualizacion para Modificar solo El folio de cheque proforma emitido
		IF (Par_TipoActualiza = Act_FolioCheque) THEN

			IF(IFNULL(Par_InstitucionID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr      := 001;
				SET Par_ErrMen      := 'La Institucion esta Vacia.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;


			IF NOT EXISTS(SELECT 	NumCtaInstit
							FROM 	CUENTASAHOTESO
							WHERE 	InstitucionID = Par_InstitucionID
							AND 	NumCtaInstit  = Par_NumCtaInstit )THEN
				SET Par_NumErr      := 002;
				SET Par_ErrMen      := 'La Cuenta Bancaria Indicada no Existe.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(SELECT COUNT(*)
					FROM 	CUENTASAHOTESO
					WHERE 	InstitucionID	= Par_InstitucionID
					AND 	NumCtaInstit  	= Par_NumCtaInstit
					AND 	Chequera 		= Var_ChequeraSi) = Entero_Cero THEN

				SET Par_NumErr      := 003;
				SET Par_ErrMen      := CONCAT('La Cuenta Bancaria ',CONVERT(Par_NumCtaInstit,CHAR), ' No Maneja Chequera' );
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TipoChequera, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr      := 004;
				SET Par_ErrMen      := 'El Tipo de Chequera esta Vacia.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

            IF(Par_TipoChequera = TipCheq_Proforma)THEN


				UPDATE CUENTASAHOTESO SET
							FolioUtilizar	= Par_FolioUtilizar,
							FechaActual		= Aud_FechaActual,
							NumTransaccion	= Aud_NumTransaccion
					WHERE 	InstitucionID 	= Par_InstitucionID
					AND 	NumCtaInstit	= Par_NumCtaInstit;

				SET Par_NumErr		:= 000;
				SET Par_ErrMen		:= CONCAT('Folio de Cheque Emitido Exitosamente, Cuenta Bancaria:', CONVERT(Par_NumCtaInstit, CHAR),'  Cheque:', Par_FolioUtilizar );
				SET Var_Consecutivo := Entero_Cero;

			ELSEIF(Par_TipoChequera = TipCheq_Estandar)THEN

				UPDATE CUENTASAHOTESO SET
							FolioUtilizarEstan	= Par_FolioUtilizar,
							FechaActual			= Aud_FechaActual,
							NumTransaccion		= Aud_NumTransaccion
					WHERE 	InstitucionID 		= Par_InstitucionID
					AND 	NumCtaInstit		= Par_NumCtaInstit;

				SET Par_NumErr		:= 000;
				SET Par_ErrMen		:= CONCAT('Folio de Cheque Emitido Exitosamente, Cuenta Bancaria:', CONVERT(Par_NumCtaInstit, CHAR),'  Cheque:', Par_FolioUtilizar );
				SET Var_Consecutivo := Entero_Cero;

            END IF;

		END IF;

	END ManejoErrores;  -- END del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				VarControl AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
