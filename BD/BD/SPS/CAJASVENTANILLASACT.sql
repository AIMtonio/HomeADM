-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASVENTANILLASACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASVENTANILLASACT`;DELIMITER $$

CREATE PROCEDURE `CAJASVENTANILLASACT`(
# =====================================================================================
# ------- STORE PARA ACTUALIZAR LAS CAJAS DE VENTANILLA ---------
# =====================================================================================
	Par_SucursalID		 INT(11),
    Par_CajaID			 INT(11),
	Par_TipoCaja		 CHAR(2),
  	Par_UsuarioID		 INT(11),
	Par_DescripCaja		 VARCHAR(50),

	Par_NomImpresora	 VARCHAR(30),
	Par_NomImpresoraCheq CHAR(30),
	Par_Estatus      	 CHAR(1),
	Par_FechaCan		 DATETIME,
	Par_MotivoCan		 VARCHAR(100),

	Par_FechaInac		 DATETIME,
	Par_MotivoInac		 VARCHAR(100),
	Par_FechaAct		 DATETIME,
	Par_MotivoAct		 VARCHAR(100),
    Par_MonedaID		 INT(11),

    Par_Cantidad		 DECIMAL(14,2),
    Par_LimiteDes		 DECIMAL(14,2),
    Par_MaxRetiro		 DECIMAL(14,2),
    Par_Naturaleza       INT,
	Par_HuellaDigital	 CHAR(1),

    Par_NumAct           TINYINT UNSIGNED,

    Par_Salida           CHAR(1),
	INOUT Par_NumErr 	 INT(11),
	INOUT Par_ErrMen  	 VARCHAR(400),

    Par_EmpresaID        INT(11),
    Aud_Usuario          INT(11),
    Aud_FechaActual      DATETIME,
    Aud_DireccionIP      VARCHAR(15),
    Aud_ProgramaID       VARCHAR(50),
    Aud_Sucursal         INT(11),
    Aud_NumTransaccion   BIGINT
)
TerminaStore: BEGIN

	-- Declaración de Variables
	DECLARE Var_MonNac			INT;
	DECLARE Var_MonExt			INT;
	DECLARE Var_CajaOriEstatus  CHAR(1);
	DECLARE Var_CajaActEstatus  CHAR(1);
	DECLARE Var_SucCaja			INT;
	DECLARE Var_SucUsuario		INT;
	DECLARE Var_UsuEstatus		CHAR(1);
	DECLARE Var_CajaEstatus		CHAR(1);
	DECLARE Var_FechaSistema	DATETIME;
	DECLARE Var_EjeProceso		CHAR(1);
	DECLARE Var_Control	    	VARCHAR(100);

	-- Declaración de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT;
	DECLARE Act_Saldo       	INT;
	DECLARE Mov_Entrada     	INT;
	DECLARE Mov_Salida      	INT;
	DECLARE Act_LimEfectivo 	INT;
	DECLARE Act_ActivaCaja		INT;
	DECLARE Act_CancelaCaja 	INT;
	DECLARE Act_Activa			INT;
	DECLARE Act_Inactiva		INT;
	DECLARE Act_Asigna			INT;
	DECLARE Act_EstatOpA		INT;
	DECLARE Act_EstatOpC		INT;
	DECLARE Act_EjeProcNo		INT;
	DECLARE Act_EjeProcSi		INT;
	DECLARE EstatusA			CHAR(1);
	DECLARE EstatusC			CHAR(1);
	DECLARE EstatusI			CHAR(1);
	DECLARE EstOpCerrada    	CHAR(1);
	DECLARE VarCajaID			INT;
	DECLARE Var_SucOrigen		INT;
	DECLARE varestop			CHAR(1);
	DECLARE Salida_NO			CHAR(1);
	DECLARE Salida_SI       	CHAR(1);
	DECLARE Valor_NO			CHAR(1);
	DECLARE Valor_SI			CHAR(1);

	DECLARE CajaAtencionPub CHAR(2);		   -- Declaramos Variable de Caja de Atencion a Cliente, Agregado por AZamora

	-- Asignación de Constantes
	SET Cadena_Vacia    	:= '';				-- Cadena Vacía
	SET Fecha_Vacia     	:= '1900-01-01';	-- Fecha Vacía
	SET Entero_Cero     	:= 0;				-- Entero en Cero
	SET Act_Saldo       	:= 1;				-- Saldo
	SET Mov_Entrada     	:= 1;           	-- Movimiento de Entrada
	SET Mov_Salida      	:= 2;           	-- Movimiento de Salida
	SET Act_LimEfectivo		:= 3;				-- Actualiza el Limite de Efectivo
	SET Act_ActivaCaja		:= 4;				-- Actualiza el Campo Estatus a Activa
	SET Act_CancelaCaja 	:= 5;				-- Actualiza el Campo Estatus a Cancelado
	SET Act_Inactiva	 	:= 6;				-- Actualiza el campo Estatus a Inactiva
	SET Act_Asigna		 	:= 7;				-- Asigna un usuario a una caja
	SET Act_EstatOpA		:= 9;				-- Actualiza el Estado de operacion A
	SET Act_EstatOpC		:= 8;				-- Actualiza el Estado de operacion C
	SET Act_EjeProcNo		:= 10;				-- Actualiza el valor de ejecutaProceso a N
	SET	Act_EjeProcSi		:= 11;				-- Actualiza el valor de ejecutaProceso a S
	SET EstatusA			:= 'A';				-- Estado de la Caja A: Activo
	SET EstatusC			:= 'C';				-- Estado de la Caja C: Cancelado
	SET EstatusI			:= 'I';				-- Estado de la Caja I: Inactivo
	SET EstOpCerrada		:= 'C';				-- Estado de Operacion de la Caja: Cerrada
	SET Aud_FechaActual 	:= NOW();			-- fecha actual
	SET Salida_NO			:= 'N';				-- No Permitir Salida
	SET Salida_SI			:= 'S';				-- Permitir Salida
	SET Valor_SI			:= 'S';				-- Valor de constante SI
	SET Valor_NO			:= 'N';				-- Valor de Constante NO
        SET CajaAtencionPub     :='CA';             -- Caja Atencion al Cliente, Agregado por AZamora


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CAJASVENTANILLASACT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		SELECT	FechaSistema INTO Var_FechaSistema
			FROM PARAMETROSSIS
			LIMIT 1;

		IF(Par_NumAct = Act_Saldo) THEN
			IF (Par_Naturaleza = Mov_Salida) THEN
				SET Par_Cantidad	:= Par_Cantidad*-1;
			END IF;

			SELECT	MonedaBaseID,	MonedaExtrangeraID INTO Var_MonNac,	Var_MonExt
				FROM PARAMETROSSIS;

			IF (Par_MonedaID = Var_MonNac) THEN
				UPDATE	CAJASVENTANILLA SET
					SaldoEfecMN    = SaldoEfecMN + Par_Cantidad
					WHERE	SucursalID 	= Par_SucursalID
					  AND	CajaID 		= Par_CajaID;
			ELSE
				UPDATE	CAJASVENTANILLA SET
					SaldoEfecME    = SaldoEfecME + Par_Cantidad
					WHERE	SucursalID	= Par_SucursalID
					  AND CajaID		= Par_CajaID;
			END IF;
		END IF;

		-- Actualiza el Límite de Efectivo de Cajas Ventanilla.
		IF(Par_NumAct = Act_LimEfectivo) THEN

			IF(IFNULL(Par_LimiteDes, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 	:= 2;
				SET	Par_ErrMen 	:= 'El Limite por Desembolso esta Vacio.' ;
				SET Var_Control	:= 'limiteDesembolsoMN' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_MaxRetiro, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 	:= 3;
				SET	Par_ErrMen 	:= 'El Maximo de Retiro esta Vacio.' ;
				SET Var_Control	:= 'maximoRetiroMN' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Cantidad, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 	:= 4;
				SET	Par_ErrMen 	:= 'El Limite de Efectivo esta Vacio.' ;
				SET Var_Control	:= 'limiteEfectivoMN' ;
				LEAVE ManejoErrores;

			ELSE
				UPDATE CAJASVENTANILLA SET
					LimiteEfectivoMN 	= Par_Cantidad,
					LimiteDesemMN 		= Par_LimiteDes,
					MaximoRetiroMN 		= Par_MaxRetiro,
					DescripcionCaja 	= Par_DescripCaja,
					NomImpresora 		= Par_NomImpresora,
					NomImpresoraCheq 	= Par_NomImpresoraCheq,
					HuellaDigital		= Par_HuellaDigital,

					EmpresaID 			= Par_EmpresaID ,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
				WHERE	SucursalID		= Par_SucursalID
				  AND	CajaID 			= Par_CajaID;

				SET	Par_NumErr 	:= 000;
				SET	Par_ErrMen 	:= 'Caja Modificada' ;
				SET Var_Control := 'cajaID' ;
			END IF;
		END IF;

		-- Actualiza el EstatusCaja al Activar las Cajas Ventanilla
		IF(Par_NumAct = Act_ActivaCaja) THEN
			IF(IFNULL(Par_CajaID, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 	:= 5;
				SET	Par_ErrMen 	:= 'El Numero de Caja esta Vacia.' ;
				SET Var_Control := 'cajaID' ;
				LEAVE ManejoErrores;
			ELSE
				UPDATE CAJASVENTANILLA SET
					Estatus 		= EstatusA,
					FechaAct 		= Par_FechaAct,
					MotivoAct 		= Par_MotivoAct
				WHERE	SucursalID	= Par_SucursalID
				  AND	CajaID 		= Par_CajaID;

				SET	Par_NumErr 	:= 000;
				SET	Par_ErrMen 	:= 'Caja Activada.' ;
				SET Var_Control	:= 'cajaID' ;
			END IF;
		END IF;

		-- Actualiza el EstatusCaja al Cancelar las Cajas Ventanilla
		IF(Par_NumAct = Act_CancelaCaja) THEN
			IF(IFNULL(Par_CajaID, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 	:= 6;
				SET	Par_ErrMen 	:= 'El Numero de Caja esta Vacia.' ;
				SET Var_Control	:= 'cajaID' ;
				LEAVE ManejoErrores;
			ELSE
				UPDATE	CAJASVENTANILLA SET
					Estatus 		= EstatusC,
					FechaCan 		= Par_FechaCan,
					MotivoCan 		= Par_MotivoCan
				WHERE	SucursalID	= Par_SucursalID
				  AND	CajaID 		= Par_CajaID;

				SET	Par_NumErr 	:= 000;
				SET	Par_ErrMen 	:= 'Caja Cancelada.' ;
				SET Var_Control	:= 'cajaID' ;
			END IF;
		END IF;

		-- Actualiza el Campo Estatus al Inactivar la Cajas Ventanilla
		IF(Par_NumAct = Act_Inactiva) THEN
			IF(IFNULL(Par_CajaID, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 	:= 7;
				SET	Par_ErrMen 	:= 'El Numero de Caja esta Vacia.' ;
				SET Var_Control	:= 'cajaID' ;
				LEAVE ManejoErrores;
			ELSE
				UPDATE	CAJASVENTANILLA SET
					Estatus			= EstatusI,
					FechaInac		= Par_FechaInac,
					MotivoInac 		= Par_MotivoInac
				WHERE	SucursalID	= Par_SucursalID
				  AND	CajaID 		= Par_CajaID;

				SET	Par_NumErr := 000;
				SET	Par_ErrMen := 'Caja Inactivada.' ;
				SET Var_Control:= 'cajaID';
			END IF;
		END IF;

		-- Actualización: Reasignación de Caja
		IF(Par_NumAct = Act_Asigna) THEN
			SELECT	IFNULL(Estatus,'') INTO Var_CajaEstatus
				FROM CAJASVENTANILLA
				WHERE	CajaID		= Par_CajaID
				  AND	SucursalID	= Par_SucursalID;

			IF(Var_CajaEstatus<>"A") THEN
				SET	Par_NumErr 	:= 10;
				SET	Par_ErrMen 	:= 'La Caja no se Encuentra Activa.' ;
				SET Var_Control	:= 'cajaID' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_UsuarioID, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 	:= 8;
				SET	Par_ErrMen 	:= 'El Usuario no Existe.' ;
				SET Var_Control	:= 'usuarioID' ;
				LEAVE ManejoErrores;
			END IF;

			SELECT	SucursalUsuario,	Estatus INTO Var_SucUsuario,	Var_UsuEstatus
				FROM USUARIOS
				WHERE	UsuarioID = Par_UsuarioID;

			SET Var_SucUsuario  := IFNULL(Var_SucUsuario, Entero_Cero);
			SET Var_UsuEstatus  := IFNULL(Var_UsuEstatus, Cadena_Vacia);

			IF (Var_UsuEstatus != EstatusA) THEN
				SET	Par_NumErr 	:= 9;
				SET	Par_ErrMen 	:= 'El Usuario no se encuentra Activo.' ;
				SET Var_Control	:= 'usuarioID' ;
				LEAVE ManejoErrores;
			END IF;

			-- Si el Usuario ya esta Asignado a una Caja,
			-- La Caja Origen debe quedar con el Campo UsuarioID Vacío para poder ser Asignado a una Nueva Caja
			SELECT	CajaID,	EstatusOpera,	SucursalID INTO	VarCajaID,	Var_CajaOriEstatus,	Var_SucCaja
				FROM CAJASVENTANILLA
				WHERE UsuarioID	= Par_UsuarioID;

			SET VarCajaID   := IFNULL(VarCajaID, Entero_Cero);

			IF(VarCajaID > Entero_Cero) THEN
				IF(Var_CajaOriEstatus != EstOpCerrada) THEN
					SET	Par_NumErr 	:= 9;
					SET	Par_ErrMen 	:= 'El Nuevo Usuario tiene una Caja que no ha sido Cerrada.' ;
					SET Var_Control	:= 'usuarioID' ;
					LEAVE ManejoErrores;
				END IF;

				UPDATE	CAJASVENTANILLA SET
						UsuarioID = Entero_Cero
					WHERE	SucursalID 	= Var_SucCaja
					  AND	CajaID 		= VarCajaID;

			END IF;

			SELECT	EstatusOpera,	SucursalID INTO Var_CajaActEstatus,	Var_SucCaja
				FROM CAJASVENTANILLA
				WHERE	SucursalID	= Par_SucursalID
				  AND	CajaID		= Par_CajaID;

			IF(Var_CajaActEstatus != EstOpCerrada) THEN
				SET	Par_NumErr 	:= 10;
				SET	Par_ErrMen 	:= CONCAT('La Caja ', CONVERT(Par_CajaID, CHAR), ' no ha sido Cerrada.') ;
				SET Var_Control	:= 'usuarioID' ;
				LEAVE ManejoErrores;
			END IF;

			-- Hacemos la Reasignación de la Caja
			UPDATE CAJASVENTANILLA SET
					UsuarioID = Par_UsuarioID
				WHERE	SucursalID	= Par_SucursalID
				  AND	CajaID 		= Par_CajaID;

			-- Cambiamos al Usuario de Sucursal
			IF(Var_SucCaja != Var_SucUsuario) THEN
				UPDATE	USUARIOS SET
					SucursalUsuario 	= Var_SucCaja
					WHERE	UsuarioID 	= Par_UsuarioID;
			END IF;

			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen 	:= 'Caja Asignada Exitosamente' ;
			SET Var_Control	:= 'cajaID' ;
		END IF;

		-- Actualiza el Campo EstatusOpera a "A" Apertura
		IF(Par_NumAct = Act_EstatOpA) THEN

			IF(IFNULL(Par_SucursalID, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 	:= 10;
				SET	Par_ErrMen 	:= 'La sucursal no Existe.' ;
				SET Var_Control	:= 'Sucursal' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CajaID, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 	:= 11;
				SET	Par_ErrMen 	:= 'El Numero de Caja esta Vacia.' ;
				SET Var_Control	:= 'cajaID' ;
				LEAVE ManejoErrores;
			END IF;

			SELECT	Estatus INTO Var_CajaEstatus
				FROM CAJASVENTANILLA
                WHERE	SucursalID	= Par_SucursalID
                  AND	CajaID		= Par_CajaID;

			SET Var_CajaEstatus := IFNULL(Var_CajaEstatus,EstatusC);

			IF (Var_CajaEstatus != EstatusA) THEN
				SET	Par_NumErr 	:= 12;
				SET	Par_ErrMen 	:= 'El Estatus de la Caja No se encuentra Activa.' ;
				SET Var_Control	:= 'cajaID' ;
				LEAVE ManejoErrores;
			END IF;

			SELECT	EstatusOpera INTO varestop
				FROM CAJASVENTANILLA
                WHERE	SucursalID	= Par_SucursalID
				 AND	CajaID		= Par_CajaID;

			IF(IFNULL(varestop, Cadena_Vacia))= EstatusA  THEN
				SET	Par_NumErr 	:= 13;
				SET	Par_ErrMen 	:= 'La Caja ya se Encuentra Abierta.' ;
				SET Var_Control := 'cajaID' ;
				LEAVE ManejoErrores;
			END IF;

			-- Valida que la Cuenta Completa de DIVISAS Exista en CUENTASCONTABLES --
			CALL CUENTACONTACAJAVAL(
				Par_SucursalID, Par_CajaID,   	Salida_NO,       Par_NumErr,       Par_ErrMen,
				Par_EmpresaID,  Aud_Usuario,  	Aud_FechaActual, Aud_DireccionIP,  Aud_ProgramaID,
				Aud_Sucursal,   Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control := 'cajaID' ;
				LEAVE ManejoErrores;
			END IF;

			UPDATE	CAJASVENTANILLA SET
				EstatusOpera	= EstatusA,

				EmpresaID		= Par_EmpresaID ,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE	SucursalID	= Par_SucursalID
			  AND	CajaID		= Par_CajaID;

			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen 	:= 'Caja Aperturada Exitosamente.' ;
			SET Var_Control := 'cajaID' ;
		END IF;--  Apertura de Cajas

		-- Actualiza el Campo EstatusOpera a "C" Cierre
		IF(Par_NumAct = Act_EstatOpC) THEN
			IF(IFNULL(Par_SucursalID, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 	:= 14;
				SET	Par_ErrMen 	:= 'La Sucursal no Existe.' ;
				SET Var_Control := 'Sucursal' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CajaID, Entero_Cero))= Entero_Cero THEN
					SET	Par_NumErr 	:= 15;
					SET	Par_ErrMen 	:= 'El Numero de Caja esta Vacia.' ;
					SET Var_Control := 'cajaID' ;
					LEAVE ManejoErrores;
			END IF;

			IF (Var_CajaEstatus != EstatusA) THEN
				SET	Par_NumErr := 16;
				SET	Par_ErrMen := 'El Estatus de la Caja No se Encuentra Activa.' ;
				SET Var_Control := 'cajaID' ;
				LEAVE ManejoErrores;
			END IF;

			SELECT	EstatusOpera	INTO	varestop
				FROM CAJASVENTANILLA
				WHERE	SucursalID	= Par_SucursalID
				  AND	CajaID		= Par_CajaID;

			IF(IFNULL(varestop, Cadena_Vacia))= EstatusC THEN
				SET	Par_NumErr 	:= 17;
				SET	Par_ErrMen 	:= 'La Caja ya se Encuentra Cerrada.' ;
				SET Var_Control := 'cajaID' ;
				LEAVE ManejoErrores;
			END IF;

			-- Se Valida que las Cajas CA Y CP no tengan Transferencias Pendientes.
			IF EXISTS(SELECT CajaOrigen
				FROM CAJASTRANSFER
				WHERE	CajaDestino		= Par_CajaID
				  AND	Estatus			= EstatusA
				  AND	SucursalDestino	= Par_SucursalID) THEN
					SET	Par_NumErr 	:= 18;
					SET	Par_ErrMen 	:= CONCAT('La Caja ',CONVERT(Par_CajaID,CHAR), ' tiene Transferencias Pendientes.');
					SET Var_Control := 'cajaID' ;
					LEAVE ManejoErrores;
			END IF;

			-- Agregamos Validacion en la Caja de Atencion Publico para que esta no termine con saldo mayor a 0, Agregado por AZamora
			IF(Par_TipoCaja = CajaAtencionPub)THEN
                IF EXISTS ( SELECT  CajaID
                              FROM BALANZADENOM
                             WHERE  SucursalID =Par_SucursalID
                               AND  CajaID  = Par_CajaID
                               AND  Cantidad > Entero_Cero)THEN
                    SET Par_NumErr      := 019;
                    SET Par_ErrMen      := CONCAT('La Caja ',CAST(Par_CajaID AS CHAR), ' tiene Saldo Pendiente de Transferir a la Caja Principal.');
                    SET Var_Control     := 'cajaID';
                    LEAVE ManejoErrores;
                END IF;
            END IF;

			UPDATE	CAJASVENTANILLA SET
				EstatusOpera	= EstatusC,

				EmpresaID		= Par_EmpresaID ,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE	SucursalID 	= Par_SucursalID
			  AND	CajaID 		= Par_CajaID;

			SET	Par_NumErr	:= 000;
			SET	Par_ErrMen	:= 'Caja Cerrada Exitosamente.' ;
			SET Var_Control := 'cajaID' ;
		END IF;



		-- Actualiza el Campo EjecutaProceso a "N" NO
		IF(Par_NumAct = Act_EjeProcNo)THEN
			UPDATE CAJASVENTANILLA SET
					EjecutaProceso 	= Valor_NO
				WHERE	SucursalID	= Par_SucursalID
				  AND	CajaID		= Par_CajaID;

			SET	Par_NumErr := 000;
			SET	Par_ErrMen := 'Proceso Terminado Exitosamente.' ;
		END IF;




		IF (Par_NumAct = Act_EjeProcSi)THEN

			-- Actualiza el Campo EjecutaProceso a "S" SI
			SELECT EjecutaProceso INTO Var_EjeProceso
				FROM CAJASVENTANILLA
				WHERE	SucursalID 	= Par_SucursalID
				  AND	CajaID 		= Par_CajaID;

			-- Validamos si el Proceso se Encuentra en Ejecución
			IF(IFNULL(Var_EjeProceso,Cadena_Vacia)) = Valor_SI  THEN
				SET	Par_NumErr := 20;
				SET	Par_ErrMen := 'Operacion en Proceso. Espere Por Favor' ;
			ELSE

				UPDATE CAJASVENTANILLA SET
					EjecutaProceso 	= Valor_SI,

					EmpresaID		= Par_EmpresaID ,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE	SucursalID 	= Par_SucursalID
				  AND	CajaID 		= Par_CajaID;

				SET	Par_NumErr := 000;
				SET	Par_ErrMen := 'Proceso Terminado Exitosamente.' ;
			END IF;
		END IF;


	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr 	AS NumErr,
					Par_ErrMen	AS ErrMen,
					Var_Control	AS control;
		END IF;

END TerminaStore$$