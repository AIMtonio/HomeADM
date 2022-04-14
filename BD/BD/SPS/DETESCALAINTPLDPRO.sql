-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETESCALAINTPLDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETESCALAINTPLDPRO`;
DELIMITER $$

CREATE PROCEDURE `DETESCALAINTPLDPRO`(
/*Store de Deteccion para operaciones de escalamiento interno*/
	Par_OperProcID			BIGINT(12),
	Par_Consecutivo			INT,
	Par_NombreProc			VARCHAR(16),
	Par_Grupo				INT,
	Par_Salida				CHAR(1),

	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen 		VARCHAR(400),
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
	DECLARE Var_Cliente				BIGINT;
	DECLARE Var_NivelRiesgo			CHAR(1);
	DECLARE Var_FecDetec			DATETIME;
	DECLARE Var_ResulRev			CHAR(1);
	DECLARE Var_CadenaUno			CHAR(1);
	DECLARE Par_ResulRev			CHAR(1);
	DECLARE Var_CurCte				INT;
	DECLARE Var_CurCred				BIGINT(12);
	DECLARE Var_Control				VARCHAR(20);		-- Control
	DECLARE Var_Consecutivo			VARCHAR(20);		-- Control
	DECLARE Var_CuentaAhoID			BIGINT(12);

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT;
	DECLARE Var_ProCuentasAh		VARCHAR(16);
	DECLARE Var_ProInversion 		VARCHAR(16);
	DECLARE Var_ProLinCred			VARCHAR(16);
	DECLARE Var_ProCredkubo			VARCHAR(16);
	DECLARE Var_ProSolCred			VARCHAR(16);
	DECLARE Var_ProSolFond			VARCHAR(16);
	DECLARE Var_ProCredito			VARCHAR(16);
	DECLARE NivelRiesgoAlto			CHAR(1);
	DECLARE ResAutorizada			CHAR(1);
	DECLARE ResRechazada			CHAR(1);
	DECLARE ResEnSegto				CHAR(1);
	DECLARE Contador				INT;
	DECLARE TipoConOper				INT;
	DECLARE SalidaNO				CHAR(1);
	DECLARE SalidaSI				CHAR(1);
	DECLARE Seguimiento				CHAR(1);
	DECLARE Var_Sucursal			INT;
	DECLARE Var_SolFondPro			INT;

	DECLARE Error_Key				INT;
	DECLARE Error_TerCiclo			INT;
	DECLARE	Sta_Activa				CHAR(1);
	DECLARE	Valor_SI				CHAR(1);

	-- Declaracion del cursor de autorizacion de credito grupal
	DECLARE CURSORCREDITO CURSOR FOR

		SELECT Cre.CreditoID,	Cre.ClienteID, Cre.SucursalID, Cre.CuentaID
			FROM INTEGRAGRUPOSCRE Inte,
				 GRUPOSCREDITO Gru,
				 SOLICITUDCREDITO Sol,
				 CREDITOS Cre
			WHERE Inte.GrupoID = Gru.GrupoID
			  AND Inte.GrupoID = Par_Grupo
			  AND Inte.SolicitudCreditoID = Sol.SolicitudCreditoID
			  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
			  AND Gru.EstatusCiclo = "C";


	-- Asignacion de constantes

	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Var_ProCuentasAh	:= 'CTAAHO';			-- Valor (ID) de acuerdo a la tabla PROCESCALINTPLD
	SET	Var_ProInversion	:= 'INVERSION'; 		-- Valor (ID) de acuerdo a la tabla PROCESCALINTPLD
	SET	Var_ProLinCred		:= 'LINEACREDITO'; 		-- Valor (ID) de acuerdo a la tabla PROCESCALINTPLD
	SET	Var_ProCredito		:= 'CREDITO'; 			-- Valor (ID) de acuerdo a la tabla PROCESCALINTPLD
	SET	Var_ProSolCred		:= 'SOLICITUDCREDITO'; 	-- Valor (ID) de acuerdo a la tabla PROCESCALINTPLD
	SET	Var_ProSolFond		:= 'SOLICITUDFONDEO'; 	-- Valor (ID) de acuerdo a la tabla PROCESCALINTPLD
	SET	Var_ProCredkubo		:= 'CREDITOXSOLICITU'; 	-- Valor (ID) de acuerdo a la tabla PROCESCALINTPLD
	SET	NivelRiesgoAlto		:= 'A';


	SET	TipoConOper			:= 3; 		-- valor de tipo de consulta para sp PLDOPEESCALAINTCON
	SET	SalidaNO			:= 'N'; 	-- Salida NO
	SET	SalidaSI			:= 'S';		-- Salida SI
	SET	ResAutorizada		:= 'A';		-- Resultado de revision valor segun tabla TIPORESULESCPLD
	SET	ResRechazada		:= 'R';		-- Resultado de revision valor segun tabla TIPORESULESCPLD
	SET	ResEnSegto			:= 'S';		-- Resultado de revision valor segun tabla TIPORESULESCPLD
	SET	Seguimiento			:= 'S';		-- para alta de segumiento (TipoResultadoSeguimiento =S)
	SET	Var_CadenaUno		:= '1';		-- Cadena Uno
	SET	Error_TerCiclo		:= 0;		-- bandera para terminar un ciclo si surgio un error
	SET	Sta_Activa			:= 'A';		-- Estatus: Activo(a)
	SET	Valor_SI			:= 'S';		-- Constante con Valor SI

	-- Inicializaciones
	SET	Par_ResulRev		:= '';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET	Par_NumErr := 999;
					SET	Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DETESCALAINTPLDPRO');
				END;

		-- Proceso Cuentas de ahorro
		IF(Par_NombreProc = Var_ProCuentasAh) THEN

			SELECT 	Cta.ClienteID,	Cta.SucursalID	INTO Var_Cliente,	Var_Sucursal
				FROM CUENTASAHO Cta,
					 CLIENTES	Cte
				WHERE Cta.CuentaAhoID = Par_OperProcID
				  AND Cte.ClienteID = Cta.ClienteID;

			CALL EVALOPEESCALAPRO(
				Var_Cliente,	Par_OperProcID,		Par_OperProcID,		Var_Sucursal,	Par_NombreProc,
				SalidaNO,		Par_NumErr,			Par_ErrMen,			Var_ResulRev,	Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr = 501) THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ResulRev =	ResEnSegto) THEN
				SET	Par_NumErr	:= 501;
				SET	Par_ErrMen	:=	"Para continuar, el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ResulRev =	ResAutorizada) THEN
				SET	Par_NumErr	:= 502;
				SET	Par_ErrMen	:= "Exito";
			END IF;

			IF(Var_ResulRev =	ResRechazada) THEN
				SET	Par_NumErr	:= 503;
				SET	Par_ErrMen	:= "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- Proceso Inversiones
		IF(Par_NombreProc = Var_ProInversion) THEN

			SELECT 	Inv.ClienteID, CuentaAhoID
					INTO
					Var_Cliente, Var_CuentaAhoID
				FROM 	INVERSIONES Inv,
						CLIENTES	Cte
					WHERE Inv.InversionID = Par_OperProcID
					AND	 Cte.ClienteID = Inv.ClienteID;

			CALL EVALOPEESCALAPRO(
				Var_Cliente,	Par_OperProcID,		Var_CuentaAhoID,		Aud_Sucursal,	Par_NombreProc,
				SalidaNO,		Par_NumErr,			Par_ErrMen,			Var_ResulRev,	Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr = 501) THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ResulRev =	ResEnSegto) THEN
				SET	Par_NumErr	:= 501;
				SET	Par_ErrMen	:=	"Para continuar, el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ResulRev =	ResAutorizada) THEN
				SET	Par_NumErr	:= 502;
				SET	Par_ErrMen	:= "Exito";
			END IF;

			IF(Var_ResulRev =	ResRechazada) THEN
				SET	Par_NumErr	:= 503;
				SET	Par_ErrMen	:= "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- Proceso Lineas de credito
		IF(Par_NombreProc = Var_ProLinCred) THEN

				SELECT 	Lin.ClienteID, CuentaID
						INTO
						Var_Cliente, Var_CuentaAhoID
				FROM 	LINEASCREDITO Lin,
						CLIENTES	Cte
					WHERE Lin.LineaCreditoID = Par_OperProcID
					AND	 Cte.ClienteID = Lin.ClienteID;

			CALL EVALOPEESCALAPRO(
				Var_Cliente,	Par_OperProcID,		Var_CuentaAhoID,		Aud_Sucursal,	Par_NombreProc,
				SalidaNO,		Par_NumErr,			Par_ErrMen,			Var_ResulRev,	Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr = 501) THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ResulRev =	ResEnSegto) THEN
				SET	Par_NumErr	:= 501;
				SET	Par_ErrMen	:=	"Para continuar, el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ResulRev =	ResAutorizada) THEN
				SET	Par_NumErr	:= 502;
				SET	Par_ErrMen	:= "Exito";
			END IF;

			IF(Var_ResulRev =	ResRechazada) THEN
				SET	Par_NumErr	:= 503;
				SET	Par_ErrMen	:= "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
				LEAVE ManejoErrores;
			END IF;

			IF( Var_ResulRev = Cadena_Vacia ) THEN
				SET	Par_NumErr	:= Entero_Cero;
				SET	Par_ErrMen	:= "Proceso de Deteccion de Escalamiento Interno Realizado Correctamente";
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- --------------------------------------------------------------------------------------
		-- Proceso Credito, Autorizacion del Credito
		-- --------------------------------------------------------------------------------------

		IF(Par_NombreProc = Var_ProCredito) THEN

			-- Creditos individuales
			IF(Par_Grupo = Entero_Cero) THEN

				SELECT Cre.ClienteID,	Cre.SucursalID, Cre.CuentaID INTO  Var_Cliente,	Var_Sucursal, Var_CuentaAhoID
					FROM CREDITOS Cre,
						 CLIENTES Cte
					WHERE CreditoID = Par_OperProcID
					  AND Cte.ClienteID = Cre.ClienteID;

				SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);


				CALL EVALOPEESCALAPRO(
					Var_Cliente,	Par_OperProcID,		Var_CuentaAhoID,	Var_Sucursal,	Par_NombreProc,
					SalidaNO,		Par_NumErr,			Par_ErrMen,			Var_ResulRev,	Par_EmpresaID,
					Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
					Aud_NumTransaccion);


				IF(Par_NumErr = 501) THEN
					LEAVE ManejoErrores;
				END IF;

				IF(Var_ResulRev =	ResEnSegto) THEN
					SET	Par_NumErr	:= 501;
					SET	Par_ErrMen	:=	"Para continuar proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
					SET	Var_Control	:= 'creditoID';
					LEAVE ManejoErrores;
				END IF;


				IF(Var_ResulRev =	ResAutorizada) THEN
					SET	Par_NumErr	:= 502;
					SET	Par_ErrMen	:= "Exito";
					SET	Var_Control	:= 'creditoID';
				END IF;


				IF(Var_ResulRev =	ResRechazada) THEN
					SET	Par_NumErr	:= 503;
					SET	Par_ErrMen	:= "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
					SET	Var_Control	:= 'creditoID';
					LEAVE ManejoErrores;

				ELSE
					SET	Par_NumErr	:= 502;
					SET	Par_ErrMen	:= "Exito";
					SET	Var_Control	:= 'creditoID';

				END IF;

			END IF;  -- Endif Creditos Individuales

			-- Creditos grupales (reciben un grupo NO un credito)
			IF(Par_Grupo != Entero_Cero) THEN

				SET	Par_NumErr	:= Entero_Cero;
				SET	Par_ErrMen	:= Cadena_Vacia;

				OPEN CURSORCREDITO;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOGRUPOCRED:LOOP

					FETCH CURSORCREDITO INTO
						Var_CurCred, Var_CurCte, Var_Sucursal, Var_CuentaAhoID;

					BEGIN

						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET	Error_Key = 1;
						DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET	Error_Key = 2;
						DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET	Error_Key = 3;
						DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET	Error_Key = 4;

						SET	Error_Key 	= Entero_Cero;

						-- Evalua si es una Operacion de Alto Riesgo que requiera Escalamiento
						CALL EVALOPEESCALAPRO(
							Var_CurCte,		Var_CurCred,		Var_CuentaAhoID,	Var_Sucursal,	Par_NombreProc,
							SalidaNO,		Par_NumErr,			Par_ErrMen,			Var_ResulRev,	Par_EmpresaID,
							Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
							Aud_NumTransaccion);

						IF(Par_NumErr = 501) THEN
							SET	Par_ErrMen := CONCAT("Para continuar proceso requiere autorizacion,
													 favor de verificar con el personal autorizado de escalamiento interno. Ope: ", CONVERT(Var_CurCred, CHAR));
							SET	Error_TerCiclo := Error_TerCiclo + 1;
							LEAVE CICLOGRUPOCRED;
						END IF;

						-- SEGUIMIENTO
						IF(Var_ResulRev = ResEnSegto) THEN
							SET	Par_NumErr	:= 501;
							SET	Par_ErrMen	:= CONCAT("Para continuar proceso requiere autorizacion,
														favor de verificar con el personal autorizado de escalamiento interno. Ope: ", CONVERT(Var_CurCred, CHAR));
							SET	Error_TerCiclo := Error_TerCiclo + 1;
							LEAVE CICLOGRUPOCRED;
						END IF;

						IF(Var_ResulRev =	ResRechazada) THEN
							SET	Par_NumErr	:= 503;
							SET	Par_ErrMen	:= CONCAT("La solicitud de Escalamiento ha sido Rechazada,
														favor de verificar con el personal autorizado de escalamiento interno. Ope: ", CONVERT(Var_CurCred, CHAR));
							SET	Error_TerCiclo := Error_TerCiclo + 1;
							LEAVE CICLOGRUPOCRED;

						END IF;

						IF(Var_ResulRev = ResAutorizada) THEN
							SET	Par_NumErr	:= 502;
							SET	Par_ErrMen	:= "Exito";

						ELSE

							SET	Par_NumErr	:= 502;
							SET	Par_ErrMen	:= "Exito";
						END IF;

						-- TODO: Generamos un nuevo numero de Transaccion
						CALL `TRANSACCIONESPRO`(Aud_NumTransaccion);


					END; -- Fin del manejo de Errores del ciclo

				END LOOP CICLOGRUPOCRED;

			END;

			CLOSE CURSORCREDITO;

			-- El ciclo termino con un Error
			IF(Error_TerCiclo != Entero_Cero) THEN
				SET	Var_Control	:= 'grupoID';
				LEAVE ManejoErrores;
			ELSE							-- El Ciclo termino sin Errores
				SET	Par_NumErr	:= 502;
				SET	Par_ErrMen	:= "Exito";
				LEAVE ManejoErrores;
			END IF;

		END IF; -- fin creditos grupales

		SET	Par_NumErr	:= 502;
		SET	Par_ErrMen	:= "Exito";

	 END IF; -- Fin del Proceso de Autorizacion de Credito

		-- --------------------------------------------------------------------------------------
		-- Proceso Solicitud de credito													---------
		-- --------------------------------------------------------------------------------------
		IF(Par_NombreProc = Var_ProSolCred) THEN

			SELECT 	Sol.ClienteID, Sol.SucursalID INTO Var_Cliente, Var_Sucursal
				FROM SOLICITUDCREDITO Sol,
					 CLIENTES Cte
				WHERE Sol.SolicitudCreditoID = Par_OperProcID
				  AND Cte.ClienteID = Sol.ClienteID;

			SET Var_Cliente := IFNULL(Var_Cliente, Entero_Cero);
			SET Var_Sucursal := IFNULL(Var_Sucursal, Entero_Cero);

			SELECT CuentaAhoID INTO Var_CuentaAhoID
				FROM CUENTASAHO Cue
				WHERE Cue.ClienteID = Var_Cliente
				  AND Cue.EsPrincipal = Valor_SI
				  AND Cue.Estatus = Sta_Activa
				  LIMIT 1;

			SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);


			-- Evalua si es una Operacion de Alto Riesgo que requiera Escalamiento
			CALL EVALOPEESCALAPRO(
				Var_Cliente,	Par_OperProcID,		Var_CuentaAhoID,		Var_Sucursal,	Par_NombreProc,
				SalidaNO,		Par_NumErr,			Par_ErrMen,			Var_ResulRev,	Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr = 501) THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ResulRev =	ResEnSegto) THEN
				SET	Par_NumErr	:= 501;
				SET	Par_ErrMen	:=	"Para continuar proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ResulRev =	ResAutorizada) THEN
				SET	Par_NumErr	:= 502;
				SET	Par_ErrMen	:= "Exito";
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ResulRev =	ResRechazada) THEN
				SET	Par_NumErr	:= 503;
				SET	Par_ErrMen	:= "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
				SET	Var_Control	:= 'solicitudCreditoID';
				LEAVE ManejoErrores;

			ELSE
				SET	Par_NumErr	:= 502;
				SET	Par_ErrMen	:= "Exito";

			END IF;


		END IF;

		-- Proceso Solicitud de fondeo
		IF(Par_NombreProc = Var_ProSolFond) THEN

			SELECT 	Fon.ClienteID, CuentaAhoID
					INTO
					Var_Cliente, Var_CuentaAhoID
				FROM 	FONDEOSOLICITUD 	Fon,
						CLIENTES	Cte
					WHERE Fon.SolFondeoID = Par_OperProcID
					AND	 Cte.ClienteID = Fon.ClienteID;

			CALL EVALOPEESCALAPRO(
				Var_Cliente,	Par_OperProcID,		Var_CuentaAhoID,		Aud_Sucursal,	Par_NombreProc,
				SalidaNO,		Par_NumErr,			Par_ErrMen,			Var_ResulRev,	Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr = 501) THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ResulRev =	ResEnSegto) THEN
				SET	Par_NumErr	:= 501;
				SET	Par_ErrMen	:=	"Para continuar, el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ResulRev =	ResAutorizada) THEN
				SET	Par_NumErr	:= 502;
				SET	Par_ErrMen	:= "Exito";
			END IF;

			IF(Var_ResulRev =	ResRechazada) THEN
				SET	Par_NumErr	:= 503;
				SET	Par_ErrMen	:= "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
				LEAVE ManejoErrores;
			END IF;

		END IF;

	END ManejoErrores;

	-- FIN MANEJO DE EXCEPCIONES ----------------------------------------------------------------------------------------------------
	 IF(Par_Salida = SalidaSI) THEN

		SELECT CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			   Par_ErrMen AS ErrMen,
			   Var_Control AS control,
			   Par_OperProcID AS consecutivo;
	 END IF;

END TerminaStore$$