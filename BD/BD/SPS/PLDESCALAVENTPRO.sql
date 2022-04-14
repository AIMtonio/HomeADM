-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDESCALAVENTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDESCALAVENTPRO`;
DELIMITER $$

CREATE PROCEDURE `PLDESCALAVENTPRO`(
/*SP para la deteccion en Escalamiento Interno por ingreso de operaciones*/
	Par_FolioEscala			BIGINT(11),		-- ID del Folio
    Par_OpcionCajaID		INT(11), 		-- OpcionCaja ID corresponde a la tabla de OPCIONESCAJA
	Par_Proceso				INT,			-- 1: Seguimiento 2: Autorizacion 3:Rechazo
	Par_ClienteID			INT(11),		-- ID del Cliente
	Par_UsuarioServicioID	INT(11),		-- ID Del Usuario si la operación lo solicita

	Par_CuentaAhoID			BIGINT(12),		-- Cuenta de Ahorro corresponde a la tabla CUENTASAHO
	Par_MonedaID			INT(11),		-- MonedaID corresponde a la tabla de MONEDAS
	Par_Monto				DECIMAL(12,2),	-- Monto de la operacion
	Par_FechaOperacion		DATETIME,		-- Fecha de la operacion
	Par_TipoResultEscID		CHAR(1),		-- Corresponde a la tabla TIPORESULESCPLD

	Par_Salida   			CHAR(1),		-- Salida S:Si N:No
	INOUT Par_NumErr   		INT(11),		-- Numero de Error
    INOUT Par_ErrMen   		VARCHAR(400),	-- Mensaje de Error
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de variables
    DECLARE Var_AplicaEnOp			CHAR(1);
    DECLARE Var_TipoPersona			CHAR(1);
    DECLARE Var_TipoInst			CHAR(1);
    DECLARE Var_Control				VARCHAR(20);
	DECLARE Var_Consecutivo			VARCHAR(20);
	DECLARE Var_FolioEscala			BIGINT(12);
	DECLARE Var_FolioID				INT(11);
	DECLARE Var_MontoDof			DECIMAL(14,2);
    DECLARE Var_TipoResultEscID		CHAR(1);
    DECLARE Var_Nacion				CHAR(1);
    DECLARE Var_EsMenorEdad			CHAR(1);
    DECLARE Var_ErrMen				VARCHAR(400);
    DECLARE Var_NumErr				INT(11);

	-- Declaracion de constantes
    DECLARE Entero_Cero				INT;
    DECLARE Decimal_Cero			DECIMAL(12,2);
    DECLARE Cadena_Vacia			CHAR(1);
    DECLARE Si_Cons					CHAR(1);
    DECLARE No_Cons					CHAR(1);
    DECLARE Salida_No				CHAR(1);
    DECLARE Salida_SI				CHAR(1);
    DECLARE TP_Fisica				CHAR(1);
    DECLARE TP_ActEmp				CHAR(1);
    DECLARE TP_Moral				CHAR(1);
    DECLARE Seguimiento				CHAR(1);
    DECLARE Autorizado				CHAR(1);
    DECLARE Rechazado				CHAR(1);
    DECLARE Finalizado				CHAR(1);
    DECLARE EstatusVigente			CHAR(1);
    DECLARE ProcesoAlta				INT;
    DECLARE ProcesoRechazo			INT;
    DECLARE ProcesoAutoriza			INT;
    DECLARE ProcesoAltaExito		INT;
    DECLARE ProcesoRechazoExito		INT;
    DECLARE ProcesoAutorizaExito	INT;
    DECLARE ProcesoSiEsMenor		INT;
    DECLARE Fecha_Vacia				DATE;

    -- Asignacion de constates
    SET Entero_Cero				:= 0;
    SET Decimal_Cero			:= 0.0;
    SET Cadena_Vacia			:= '';
    SET Si_Cons					:= 'S';
    SET No_Cons					:= 'N';
    SET Salida_No				:= 'N';
    SET Salida_SI				:= 'S';
    SET TP_Fisica				:= 'F';			-- Tipo de Persona Fisica
    SET TP_ActEmp				:= 'A';			-- Tipo de Persona con Actividad Empresarial
    SET TP_Moral				:= 'M';			-- Tipo de Persona Moral
    SET Seguimiento				:= 'S';			-- Estatus en Seguimiento
    SET Autorizado				:= 'A';			-- Estatus en Autorizacion
    SET Rechazado				:= 'R';			-- Estatus en Rechazado
    SET Finalizado				:= 'F';			-- Estatus Finalizado
    SET EstatusVigente			:= 'V';			-- Estatus Vigente
    SET ProcesoAlta				:= 1;
    SET ProcesoRechazo			:= 3;
    SET ProcesoAutoriza			:= 2;
    SET ProcesoAltaExito		:= 501;
    SET ProcesoAutorizaExito	:= 502;
    SET ProcesoRechazoExito		:= 503;
    SET ProcesoSiEsMenor		:= 504;
    SET Fecha_Vacia				:= '1900-01-01';


    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDESCALAVENTPRO');
		END;

        /*Proceso de deteccion y escalamiento a la operacion*/
        IF(ProcesoAlta = Par_Proceso) THEN

			IF(IFNULL(Par_ClienteID, Entero_Cero) > Entero_Cero)THEN
				SELECT 	IFNULL(EsMenorEdad,No_Cons) INTO Var_EsMenorEdad
						FROM CLIENTES
							WHERE ClienteID = IFNULL(Par_ClienteID,Entero_Cero);
			END IF;

			IF(IFNULL(Var_EsMenorEdad,No_Cons)=Si_Cons)THEN
				SET Par_NumErr	:= ProcesoSiEsMenor;
				SET Par_ErrMen	:= 'La Operacion No Requiere de Escalamiento.';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_OpcionCajaID,Entero_Cero)=Entero_Cero)THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := CONCAT('La Opcion de Caja se Encuentra Vacia.');
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_MonedaID,Entero_Cero)=Entero_Cero)THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := CONCAT('La Moneda se Encuentra Vacia.');
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Monto,Decimal_Cero)=Decimal_Cero)THEN
				SET Par_NumErr := 003;
				SET Par_ErrMen := CONCAT('El Monto de la Operacion se Encuentra Vacio.');
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaOperacion,Fecha_Vacia)=Fecha_Vacia)THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := CONCAT('La Fecha de Operacion se Encuentra Vacia.');
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TipoResultEscID,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr := 005;
				SET Par_ErrMen := CONCAT('El Tipo de Resultado de Escalamiento se Encuentra Vacio.');
				LEAVE ManejoErrores;
			END IF;

			SET Var_AplicaEnOp	:= (SELECT SujetoPLDEscala FROM OPCIONESCAJA WHERE OpcionCajaID=Par_OpcionCajaID);
            IF(Var_AplicaEnOp = Si_Cons) THEN
				SET Var_TipoInst := (SELECT TipoInstruMonID FROM OPCIONESCAJA WHERE OpcionCajaID=Par_OpcionCajaID);
				SET Var_TipoInst := IFNULL(Var_TipoInst,Cadena_Vacia);

                IF(IFNULL(Par_ClienteID, Entero_Cero) = Entero_Cero) THEN
					IF(IFNULL(Par_CuentaAhoID, Entero_Cero)!= Entero_Cero) THEN
						SET Par_ClienteID := (SELECT ClienteID from CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);
                    END IF;
				END IF;

                IF(IFNULL(Par_ClienteID, Entero_Cero) != Entero_Cero) THEN
					SELECT TipoPersona,Nacion INTO Var_TipoPersona, Var_Nacion FROM CLIENTES WHERE ClienteID=Par_ClienteID;
                    ELSE
					SELECT TipoPersona,Nacionalidad INTO Var_TipoPersona, Var_Nacion FROM USUARIOSERVICIO WHERE UsuarioServicioID=Par_UsuarioServicioID;
                END IF;

                SET Var_TipoPersona := IFNULL(Var_TipoPersona, Cadena_Vacia);
                SET Var_TipoPersona := IF(Var_TipoPersona = TP_ActEmp, TP_Fisica, Var_TipoPersona);
                SET Var_MontoDof := (SELECT ROUND((IF(H.TipCamDof IS NULL, M.TipCamDof, H.TipCamDof) * Par_Monto),2) as Monto
										FROM `HIS-MONEDAS` AS H,MONEDAS AS M
										   WHERE H.MonedaID = Par_MonedaID AND M.MonedaID=Par_MonedaID
											ORDER BY H.FechaActual DESC LIMIT 1);

				SET Var_MontoDof := IFNULL(Var_MontoDof, Decimal_Cero);

				SET Var_FolioID := (SELECT FolioID
										FROM PARAMETROSESCALA AS P
											  LEFT JOIN `HIS-MONEDAS` AS H ON P.MonedaComp=H.MonedaID
											  LEFT JOIN MONEDAS AS M ON P.MonedaComp= M.MonedaID
											WHERE Estatus=EstatusVigente
												AND TipoPersona = Var_TipoPersona
                                                AND P.NacMoneda = Var_Nacion -- Nacionalidad del cliente
												AND (IF(H.TipCamDof IS NULL, M.TipCamDof, H.TipCamDof) * P.LimiteInferior) <= Var_MontoDof
												AND TipoInstrumento = Var_TipoInst
													ORDER BY H.FechaActual DESC LIMIT 1);

				IF(IFNULL(Var_FolioID, Entero_Cero) != Entero_Cero) THEN
					-- Verificar si ya existe una operacion escalada
					SELECT FolioEscala, TipoResultEscID INTO Var_FolioEscala, Var_TipoResultEscID
						FROM TMPPLDVENESCALA AS Tmp
							WHERE OpcionCajaID = Par_OpcionCajaID
								AND (ClienteID = Par_ClienteID OR
									UsuarioServicioID = Par_UsuarioServicioID OR
									CuentaAhoID = Par_CuentaAhoID)
								AND Monto = Par_Monto
								AND FechaOperacion = Par_FechaOperacion
								AND TipoResultEscID != Finalizado
                                ORDER BY FechaActual DESC limit 1
								;
					IF(IFNULL(Var_FolioEscala, Entero_Cero) = Entero_Cero) THEN
						CALL TMPPLDVENESCALAALT(
							Par_OpcionCajaID, 	Par_ClienteID, 		Par_UsuarioServicioID, 		Par_CuentaAhoID, 		Par_MonedaID,
							Par_Monto, 			Par_FechaOperacion, Par_TipoResultEscID, 		Salida_No, 				Par_NumErr,
							Par_ErrMen, 		Par_FolioEscala,	Aud_EmpresaID, 				Aud_Usuario, 			Aud_FechaActual,
                            Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal, 				Aud_NumTransaccion);

						SET Var_Consecutivo	:= Par_FolioEscala;
						LEAVE ManejoErrores;
					  ELSE
						IF(Var_TipoResultEscID = Seguimiento) THEN
							SET Par_NumErr 		:= 501;
							SET	Par_ErrMen		:= CONCAT("Para continuar Proceso Requiere Autorizacion, Favor de Verificar con el Personal Autorizado de Escalamiento Interno. Folio de la Solicitud: ",Var_FolioEscala,".");
							SET Var_Consecutivo	:= Var_FolioEscala;
							LEAVE ManejoErrores;
						ELSEIF(Var_TipoResultEscID = Autorizado) THEN
								SET Par_NumErr 		:= 502;
								SET	Par_ErrMen		:= CONCAT("");
								SET Var_Consecutivo	:= Var_FolioEscala;
								LEAVE ManejoErrores;
                              ELSEIF(Var_TipoResultEscID = Rechazado) THEN
								SET Par_NumErr 		:= 503;
								SET	Par_ErrMen		:= CONCAT("La solicitud de Escalamiento ha sido Rechazada, Favor de Verificar con el Personal Autorizado de Escalamiento Interno. ");
								SET Var_Consecutivo	:= Var_FolioEscala;
								LEAVE ManejoErrores;
						END IF;

					END IF;
				  ELSE
					SET Par_NumErr	:= Entero_Cero;
					SET Par_ErrMen	:= 'La Operacion No Requiere de Escalamiento.';
                    LEAVE ManejoErrores;
				END IF;
			  ELSE
				SET Par_NumErr	:= Entero_Cero;
				SET Par_ErrMen	:= 'La Operacion No Esta Sujeta a PLD.';
                LEAVE ManejoErrores;
			END IF;
		END IF;

        /*Proceso de Autorizacion o Rechazo de la solicitud*/
        IF(ProcesoAutoriza = Par_Proceso OR ProcesoRechazo = Par_Proceso OR 4  = Par_Proceso) THEN
			CALL TMPPLDVENESCALACT(
				Par_FolioEscala,	Par_TipoResultEscID,		Salida_No,				Par_NumErr,				Par_ErrMen,
                Aud_EmpresaID,		Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
                Aud_Sucursal,		Aud_NumTransaccion);

			SET Var_Consecutivo := Par_FolioEscala;

			IF(Par_NumErr != ProcesoAltaExito) THEN
				LEAVE ManejoErrores;
			END IF;
        END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'La Operacion No Requiere de Escalamiento.';
        SET Var_Consecutivo := '';

	END ManejoErrores;

    IF(Par_NumErr!=ProcesoRechazoExito AND Par_NumErr!=ProcesoSiEsMenor)THEN
		SET Var_NumErr := Par_NumErr;
		SET Var_ErrMen := IF(Par_NumErr!=Entero_Cero OR Par_NumErr!=ProcesoAutorizaExito,CONCAT(Par_ErrMen),Cadena_Vacia);

		CALL INGRESOSOPERAIDENTIVAL(
			Par_OpcionCajaID,	Par_ClienteID,		Par_UsuarioServicioID,		Par_Monto,				Salida_No,
			Par_NumErr,			Par_ErrMen,	        Aud_EmpresaID,				Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,				Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			IF(Var_NumErr!= Entero_Cero AND Var_ErrMen!=Cadena_Vacia)THEN
				SET Var_ErrMen := CONCAT(Var_ErrMen,'<br>');
			 ELSE
				SET Var_ErrMen := Cadena_Vacia;
			END IF;
			SET Var_ErrMen := IF(Par_NumErr!=Entero_Cero,CONCAT(Var_ErrMen,Par_ErrMen),Cadena_Vacia);
			SET Par_ErrMen := Var_ErrMen;
		END IF;

        IF(Par_NumErr=Entero_Cero) THEN
			SET Par_NumErr :=Var_NumErr;
            SET Par_ErrMen := Var_ErrMen;
		END IF;
	ELSEIF(Par_NumErr=ProcesoSiEsMenor)THEN
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'La Operacion No Requiere de Escalamiento.';
	END IF;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;
END TerminaStore$$