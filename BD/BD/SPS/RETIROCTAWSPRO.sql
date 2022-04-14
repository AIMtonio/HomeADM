-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RETIROCTAWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RETIROCTAWSPRO`;
DELIMITER $$


CREATE PROCEDURE `RETIROCTAWSPRO`(


	Par_Num_Socio			INT(11),
	Par_Num_Cta				BIGINT(12),
	Par_Monto				DECIMAL(14,2),
	Par_Fecha_Mov			DATE,
	Par_Folio_Pda			VARCHAR(20),
	Par_Id_Usuario			VARCHAR(100),
	Par_Clave				VARCHAR(40),
	Par_Dispositivo			VARCHAR(40),

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)

TerminaStore: BEGIN


DECLARE Var_CodigoResp		INT(1);
DECLARE Var_CodigoDesc		VARCHAR(100);
DECLARE Var_FechaAutoriza	VARCHAR(20);
DECLARE Var_Saldo			DECIMAL(14,2);
DECLARE Var_SaldoDisp		DECIMAL(14,2);

DECLARE Var_DescripcionMov	VARCHAR(45);
DECLARE Var_MonedaID		INT(11);
DECLARE Var_SucurCliente	INT(5);
DECLARE Var_FechaSistema	DATE;
DECLARE Var_NumErr			INT(11);
DECLARE Var_MenErr			VARCHAR(100);
DECLARE Var_Poliza			BIGINT;

DECLARE Var_UsuarioID		INT(11);
DECLARE Var_SucursalID		INT(11);
DECLARE Var_CajaID			INT(11);
DECLARE Var_Promotor        INT(11);


DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE Entero_Cero			INT(1);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Estatus_Activo		CHAR(1);
DECLARE Salida_NO			CHAR(1);

DECLARE TipoMov				INT(4);
DECLARE NatMovimiento		CHAR(1);
DECLARE AltaEncPoliza		CHAR(1);
DECLARE ConceptoConta		INT(4);
DECLARE AltaPoliza			CHAR(1);
DECLARE ConceptoAho			INT(4);
DECLARE NatMovConta			CHAR(1);

DECLARE TipoOperacion		INT(1);

DECLARE NatMoviDeno			INT(1);
DECLARE DenominacionID 		INT(4);
DECLARE DesMovCaja 			VARCHAR(50);

DECLARE Par_NumErr      	INT;
DECLARE Par_ErrMen      	VARCHAR(400);

DECLARE	Cliente				INT;
DECLARE	EstatusC			CHAR(1);
DECLARE	SaldoDisp			DECIMAL(12,2);
DECLARE	MonedaCon			INT;

DECLARE	EstatusActivo		CHAR(1);




SET Decimal_Cero			:= 0.00;
SET Entero_Cero				:= 0;
SET Cadena_Vacia			:= '';
SET Fecha_Vacia				:= '1900-01-01';
SET Estatus_Activo			:= 'A';
SET Salida_NO				:= 'N';

SET TipoMov					:= 29;
SET NatMovimiento			:= 'C';
SET AltaEncPoliza			:= 'S';
SET ConceptoConta			:= 46;
SET AltaPoliza				:= 'S';
SET ConceptoAho				:= 1;
SET NatMovConta				:= 'C';
SET	EstatusActivo			:= 'A';


SET TipoOperacion			:= 11;

SET NatMoviDeno				:= 2;
SET DenominacionID			:= 7;
SET DesMovCaja 				:= 'RETIRO DE EFECTIVO A CUENTA';

SET Par_NumErr  			:=    0;
SET Par_ErrMen  			:=   '';



SET Var_CodigoResp			:= 0;
SET Var_CodigoDesc			:= 'Transaccion Rechazada';
SET Var_FechaAutoriza		:= CONCAT(CURRENT_DATE,'T',CURRENT_TIME);


SELECT UsuarioID,  '127.0.0.1' ,	EmpresaID,	SucursalUsuario
	  FROM USUARIOS
	  WHERE Clave = Par_Id_Usuario
	  AND Contrasenia = Par_Clave
	  AND Estatus = Estatus_Activo

INTO Aud_Usuario,	Aud_DireccionIP,	Par_EmpresaID,	Aud_Sucursal;


SET Aud_FechaActual	:= NOW();
SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
SET Var_DescripcionMov	:= (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = TipoMov);
SET Var_MonedaID		:= (SELECT MonedaID FROM CUENTASAHO WHERE CuentaAhoID = Par_Num_Cta);
SET Var_SucurCliente	:= (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Par_Num_Socio);



SELECT Usu.UsuarioID, Usu.SucursalUsuario, CajaID
	FROM CAJASVENTANILLA Ven,
		 USUARIOS Usu
	WHERE Ven.UsuarioID = Usu.UsuarioID
	AND Usu.UsuarioID = Aud_Usuario
	LIMIT 1

INTO Var_UsuarioID, Var_SucursalID, Var_CajaID;


ManejoErrores:BEGIN

	IF(IFNULL(Par_Num_Socio,Entero_Cero))= Entero_Cero THEN

        SET Par_NumErr := 2;
		SET Par_ErrMen := 'El numero de socio esta vacio.';

		SELECT  Par_NumErr 		    AS CodigoResp,
				Par_ErrMen		    AS CodigoDesc,
				'true'				AS EsValido,
				Var_FechaAutoriza	AS AutFecha,
				Aud_NumTransaccion	AS FolioAut,
				Var_Saldo			AS SaldoTot,
				Var_SaldoDisp		AS SaldoDisp;
				LEAVE ManejoErrores;
			END IF;

     IF(IFNULL(Par_Num_Cta,Entero_Cero))= Entero_Cero THEN

		SET Par_NumErr := 3;
		SET Par_ErrMen := 'El numero de cuenta esta vacio.';

		SELECT  Par_NumErr 		    AS CodigoResp,
				Par_ErrMen		    AS CodigoDesc,
				'true'				AS EsValido,
				Var_FechaAutoriza	AS AutFecha,
				Aud_NumTransaccion	AS FolioAut,
				Var_Saldo			AS SaldoTot,
				Var_SaldoDisp		AS SaldoDisp;
				LEAVE ManejoErrores;
			END IF;

	IF(IFNULL(Par_Monto,Decimal_Cero))= Decimal_Cero THEN

		SET Par_NumErr := 4;
		SET Par_ErrMen := 'El monto es cero.';

		SELECT  Par_NumErr 		    AS CodigoResp,
				Par_ErrMen		    AS CodigoDesc,
				'true'				AS EsValido,
				Var_FechaAutoriza	AS AutFecha,
				Aud_NumTransaccion	AS FolioAut,
				Var_Saldo			AS SaldoTot,
				Var_SaldoDisp		AS SaldoDisp;
				LEAVE ManejoErrores;
			END IF;

	IF(IFNULL(Par_Fecha_Mov,Fecha_Vacia))= Fecha_Vacia THEN

		SET Par_NumErr := 5;
		SET Par_ErrMen := 'La Fecha esta vacia.';

		SELECT  Par_NumErr 		    AS CodigoResp,
				Par_ErrMen		    AS CodigoDesc,
				'true'				AS EsValido,
				Var_FechaAutoriza	AS AutFecha,
				Aud_NumTransaccion	AS FolioAut,
				Var_Saldo			AS SaldoTot,
				Var_SaldoDisp		AS SaldoDisp;
				LEAVE ManejoErrores;
			END IF;

		IF(IFNULL(Par_Id_Usuario,Cadena_Vacia))= Cadena_Vacia THEN

				SET Par_NumErr := 6;
				SET Par_ErrMen := 'El Usuario esta vacio.';

				SELECT  Par_NumErr 		    AS CodigoResp,
						Par_ErrMen		    AS CodigoDesc,
						'true'				AS EsValido,
						Var_FechaAutoriza	AS AutFecha,
						Aud_NumTransaccion	AS FolioAut,
						Var_Saldo			AS SaldoTot,
						Var_SaldoDisp		AS SaldoDisp;
						LEAVE ManejoErrores;
					END IF;

		IF(IFNULL(Par_Clave,Cadena_Vacia))= Cadena_Vacia THEN

				SET Par_NumErr := 7;
				SET Par_ErrMen := 'La clave del usuario esta vacia.';

				SELECT  Par_NumErr 		    AS CodigoResp,
						Par_ErrMen		    AS CodigoDesc,
						'true'				AS EsValido,
						Var_FechaAutoriza	AS AutFecha,
						Aud_NumTransaccion	AS FolioAut,
						Var_Saldo			AS SaldoTot,
						Var_SaldoDisp		AS SaldoDisp;
						LEAVE ManejoErrores;
					END IF;


			IF NOT EXISTS(SELECT ClienteID
						  FROM CLIENTES
						  WHERE ClienteID = Par_Num_Socio
						  AND Estatus = Estatus_Activo)THEN

						SET Par_NumErr := 8;
						SET Par_ErrMen := 'El cliente no existe.';

				SELECT  Par_NumErr 		    AS CodigoResp,
						Par_ErrMen		    AS CodigoDesc,
						'true'				AS EsValido,
						Var_FechaAutoriza	AS AutFecha,
						Aud_NumTransaccion	AS FolioAut,
						Var_Saldo			AS SaldoTot,
						Var_SaldoDisp		AS SaldoDisp;
					LEAVE ManejoErrores;
			    END IF;


			IF NOT EXISTS(SELECT CuentaAhoID
						FROM CUENTASAHO
						WHERE CuentaAhoID = Par_Num_Cta
						AND ClienteID = Par_Num_Socio
						AND Estatus = Estatus_Activo)THEN

				SET Par_NumErr := 9;
				SET Par_ErrMen := 'La cuenta es incorrecta.';

					SELECT  Par_NumErr 		    AS CodigoResp,
							Par_ErrMen		    AS CodigoDesc,
							'true'				AS EsValido,
							Var_FechaAutoriza	AS AutFecha,
							Aud_NumTransaccion	AS FolioAut,
							Var_Saldo			AS SaldoTot,
							Var_SaldoDisp		AS SaldoDisp;
						LEAVE ManejoErrores;
					END IF;



   SET Var_Promotor := (SELECT PromotorID FROM PROMOTORES Pro
                        INNER JOIN USUARIOS Usu
                        ON Usu.UsuarioID = Pro.UsuarioID
                        WHERE Usu.Clave = Par_Id_Usuario
                        AND Usu.Contrasenia = Par_Clave);

	         IF NOT EXISTS(SELECT Cli.PromotorActual
				           FROM PROMOTORES Pro
					       INNER JOIN CLIENTES Cli
						   ON Cli.PromotorActual = Pro.PromotorID
						   WHERE PromotorActual = Var_Promotor
						   AND Cli.ClienteID = Par_Num_Socio)THEN

			SET Par_NumErr := 10;
			SET Par_ErrMen := 'El usuario no corresponde al promotor del Cliente o la contrasena es incorrecta.';

				SELECT  Par_NumErr 		    AS CodigoResp,
						Par_ErrMen		    AS CodigoDesc,
						'true'				AS EsValido,
						Var_FechaAutoriza	AS AutFecha,
						Aud_NumTransaccion	AS FolioAut,
						Var_Saldo			AS SaldoTot,
						Var_SaldoDisp		AS SaldoDisp;
				LEAVE ManejoErrores;
				END IF;



CALL SALDOSAHORROCON( Cliente,	SaldoDisp,	MonedaCon,	EstatusC,	Par_Num_Cta);

if(EstatusC<>EstatusActivo) then
	SET Par_NumErr := 12;
	SET Par_ErrMen := 'No se pueden hacer movimientos en esta cuenta.';

	SELECT  Par_NumErr 		    AS CodigoResp,
			Par_ErrMen		    AS CodigoDesc,
			'false'				AS EsValido,
			Var_FechaAutoriza	AS AutFecha,
			Entero_Cero			AS FolioAut,
			Decimal_Cero		AS SaldoTot,
			Decimal_Cero		AS SaldoDisp;
	 LEAVE TerminaStore;
  end if;

	if(EstatusC=EstatusActivo) then
		if(SaldoDisp<Par_Monto) then

    SET Par_NumErr := 11;
	SET Par_ErrMen := 'Saldo Insuficiente.';

	SELECT  Par_NumErr 		    AS CodigoResp,
			Par_ErrMen		    AS CodigoDesc,
			'false'				AS EsValido,
			Var_FechaAutoriza	AS AutFecha,
			Entero_Cero			AS FolioAut,
			Decimal_Cero		AS SaldoTot,
			Decimal_Cero		AS SaldoDisp;
				LEAVE TerminaStore;
		end if;
	end if;






			CALL CONTAAHORROPRO(Par_Num_Cta,		Par_Num_Socio,		Aud_NumTransaccion,		Par_Fecha_Mov,		Var_FechaSistema,
								NatMovimiento,		Par_Monto,		 	Var_DescripcionMov,		Par_Num_Cta,		TipoMov,
								Var_MonedaID,		Var_SucurCliente,	AltaEncPoliza,			ConceptoConta,		Var_poliza,
								AltaPoliza,			ConceptoAho,		NatMovConta,			Var_NumErr,			Var_MenErr,
								Entero_Cero,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(IFNULL(Var_NumErr, Entero_Cero) != Entero_Cero) THEN
	        SET Par_NumErr := 13;
			SET Par_ErrMen := 'Error en el retiro de ahorro.';

				SELECT  Par_NumErr 		    AS CodigoResp,
						Par_ErrMen		    AS CodigoDesc,
						'true'				AS EsValido,
						Var_FechaAutoriza	AS AutFecha,
						Aud_NumTransaccion	AS FolioAut,
						Var_Saldo			AS SaldoTot,
						Var_SaldoDisp		AS SaldoDisp;
				LEAVE ManejoErrores;
			END IF;


       SET Entero_Cero := 0;



			CALL CAJASMOVSALT(
								Var_SucursalID, 	Var_CajaID, 	Par_Fecha_Mov, 		Aud_NumTransaccion, 	Var_MonedaID,
								Par_Monto,			Decimal_Cero,	TipoOperacion,		Var_CajaID,				Par_Num_Cta,
								Decimal_Cero,		Decimal_Cero,	Salida_NO,			Var_NumErr, 			Var_MenErr,
								Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
								Aud_Sucursal,		Aud_NumTransaccion);

			IF(IFNULL(Var_NumErr, Entero_Cero) != Entero_Cero) THEN

            SET Par_NumErr := 14;
			SET Par_ErrMen := 'Error al realizar movimiento en caja.';

				SELECT  Par_NumErr 		    AS CodigoResp,
						Par_ErrMen		    AS CodigoDesc,
						'true'				AS EsValido,
						Var_FechaAutoriza	AS AutFecha,
						Aud_NumTransaccion	AS FolioAut,
						Var_Saldo			AS SaldoTot,
						Var_SaldoDisp		AS SaldoDisp;
				LEAVE ManejoErrores;
			END IF;


			SET TipoOperacion	:= 31;
			CALL CAJASMOVSALT(
								Var_SucursalID, 	Var_CajaID, 	Par_Fecha_Mov, 		Aud_NumTransaccion, 	Var_MonedaID,
								Par_Monto,			Decimal_Cero,	TipoOperacion,		Var_CajaID,				Par_Num_Cta,
								Decimal_Cero,		Decimal_Cero,	Salida_NO,			Var_NumErr, 			Var_MenErr,
								Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
								Aud_Sucursal,		Aud_NumTransaccion);


			IF(IFNULL(Var_NumErr, Entero_Cero) != Entero_Cero) THEN

            SET Par_NumErr := 15;
			SET Par_ErrMen := 'Error al realizar movimiento en caja.';

				SELECT  Par_NumErr 		    AS CodigoResp,
						Par_ErrMen		    AS CodigoDesc,
						'true'				AS EsValido,
						Var_FechaAutoriza	AS AutFecha,
						Aud_NumTransaccion	AS FolioAut,
						Var_Saldo			AS SaldoTot,
						Var_SaldoDisp		AS SaldoDisp;
				LEAVE ManejoErrores;
			END IF;



			SET AltaEncPoliza  := 'N';
			CALL DENOMINAMOVSALT(
						Var_SucursalID, 		Var_CajaID,			Par_Fecha_Mov, 			Aud_NumTransaccion, 		NatMoviDeno,
						DenominacionID,		    Par_Monto, 			Par_Monto,				Var_MonedaID,			    AltaEncPoliza,
						Var_CajaID,				Par_Num_Cta,		Salida_NO, 				Par_EmpresaID, 				DesMovCaja,
						Par_Num_Socio,			Var_Poliza,			Var_NumErr, 			Var_MenErr,					Entero_Cero,
						Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,
						Aud_NumTransaccion);

			SET Entero_Cero := 0;

			IF(IFNULL(Var_NumErr, Entero_Cero) != Entero_Cero) THEN

            SET Par_NumErr := 16;
			SET Par_ErrMen := 'Error en la denominacion.';

				SELECT  Par_NumErr 		    AS CodigoResp,
						Par_ErrMen		    AS CodigoDesc,
						'true'				AS EsValido,
						Var_FechaAutoriza	AS AutFecha,
						Aud_NumTransaccion	AS FolioAut,
						Var_Saldo			AS SaldoTot,
						Var_SaldoDisp		AS SaldoDisp;
				LEAVE ManejoErrores;
			ELSE
				SET Var_CodigoResp		:= 1;
				SET Var_CodigoDesc		:= 'Transaccion Aceptada';

				SELECT IFNULL(Saldo,Decimal_Cero), IFNULL(SaldoDispon,Decimal_Cero)
				FROM CUENTASAHO WHERE CuentaAhoID = Par_Num_Cta

                INTO   Var_Saldo, Var_SaldoDisp;
		END IF;


	END ManejoErrores;




IF (Var_CodigoResp = Entero_Cero)THEN
	SELECT  Var_CodigoResp 		AS CodigoResp,
			Var_CodigoDesc		AS CodigoDesc,
			'false'				AS EsValido,
			Var_FechaAutoriza	AS AutFecha,
			Entero_Cero			AS FolioAut,
			Decimal_Cero		AS SaldoTot,
			Decimal_Cero		AS SaldoDisp;
ELSE
	SELECT  Var_CodigoResp 		AS CodigoResp,
			Var_CodigoDesc		AS CodigoDesc,
			'true'				AS EsValido,
			Var_FechaAutoriza	AS AutFecha,
			Aud_NumTransaccion	AS FolioAut,
			Var_Saldo			AS SaldoTot,
			Var_SaldoDisp		AS SaldoDisp;
END IF;

END TerminaStore$$