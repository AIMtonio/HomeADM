-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ABONOCTAWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ABONOCTAWSPRO`;
DELIMITER $$


CREATE PROCEDURE `ABONOCTAWSPRO`(



	Par_Num_Socio		INT(11),
	Par_Num_Cta			BIGINT(12),
	Par_Monto			DECIMAL(14,2),
	Par_Fecha_Mov		DATE,
	Par_Id_Usuario		VARCHAR(100),
	Par_Clave			VARCHAR(40),

	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
		)

TerminaStore: BEGIN


DECLARE Var_Saldo		DECIMAL(14,2);
DECLARE Var_SaldoDisp	DECIMAL(14,2);
DECLARE Var_DescripcionMov	VARCHAR(45);
DECLARE Var_MonedaID	INT(11);
DECLARE Var_SucurCli	INT(5);
DECLARE Var_Poliza		BIGINT;
DECLARE Var_NumErr		INT(11);
DECLARE Var_MenErr		VARCHAR(100);
DECLARE Var_FechaSis	DATE;
DECLARE Var_UsuarioID	INT(11);
DECLARE Var_SucursalID	INT(11);
DECLARE Var_CajaID		INT(11);
DECLARE NatMovi			INT(1);
DECLARE Var_Promotor    INT(11);
DECLARE Var_EstatusCaja		char(1);
DECLARE Var_RolFR			int(11);
DECLARE Var_EstatusUsuario	char(1);


DECLARE	Con_GrupoNoSoLiWS	INT;
DECLARE	Con_PromotorWS	    INT;


DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE Entero_Cero		INT(1);
DECLARE Estatus_Activo	CHAR(1);
DECLARE NatMovimiento	CHAR(1);
DECLARE TipoMov			INT(4);
DECLARE AltaEncPoliza	CHAR(1);
DECLARE ConceptoConta	INT(4);
DECLARE AltaPoliza		CHAR(1);
DECLARE NatMovConta		CHAR(1);
DECLARE ConceptoAho		INT(4);
DECLARE Aut_Fecha		VARCHAR(20);
DECLARE TipoOperacion	INT(1);
DECLARE Salida_NO		CHAR(1);
DECLARE DenominacionID 	INT(4);
DECLARE DesMovCaja 		VARCHAR(50);

DECLARE Par_NumErr      INT;
DECLARE Par_ErrMen      VARCHAR(400);

SET	Con_GrupoNoSoLiWS	:= 1;
SET	Con_PromotorWS	    := 2;
SET Decimal_Cero	:= 0.00;
SET Entero_Cero		:= 0;
SET Estatus_Activo	:= 'A';
SET NatMovimiento	:= 'A';
SET TipoMov			:= 28;
SET AltaEncPoliza	:= 'S';
SET ConceptoConta	:= 45;
SET AltaPoliza		:= 'S';
SET NatMovConta		:= 'A';
SET ConceptoAho		:= 1;
SET TipoOperacion	:= 1;
SET Salida_NO		:= 'N';
SET DenominacionID	:= 7;
SET DesMovCaja 		:= 'ABONO DE EFECTIVO EN CUENTA';
SET NatMovi			:=1;

ManejoErrores:BEGIN

SELECT UsuarioID,  '127.0.0.1' ,	1 ,	SucursalUsuario
	FROM USUARIOS
		WHERE Clave = Par_Id_Usuario
			AND Contrasenia = Par_Clave
			AND Estatus = Estatus_Activo
	INTO Aud_Usuario,	Aud_DireccionIP,	Par_EmpresaID,	Aud_Sucursal;

SET Aud_FechaActual	:= NOW();
SET Aut_Fecha		:= CONCAT(CURRENT_DATE,'T',CURRENT_TIME);


	IF EXISTS (SELECT Usu.UsuarioID
				FROM USUARIOS Usu,
					 PARAMETROSCAJA Par,
					 CAJASVENTANILLA Caj
				WHERE Usu.Clave = Par_Id_Usuario
					AND Usu.Contrasenia = Par_Clave
					AND Usu.RolID = Par.EjecutivoFR
					AND Usu.Estatus = Estatus_Activo
					AND Usu.UsuarioID = Caj.UsuarioID
					AND Caj.Estatus = Estatus_Activo
					AND Caj.EstatusOpera = Estatus_Activo)THEN

		IF(IFNULL(Par_Num_Socio,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El numero de socio esta vacio.';

			SELECT  Par_NumErr 		        AS CodigoResp,
					Par_ErrMen	            AS CodigoDesc,
					'false' 				AS EsValido,
					Aut_Fecha				AS AutFecha,
					'0'				 		AS FolioAut,
					'0.00' 					AS SaldoTot,
					'0.00' 					AS SaldoDisp;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Num_Cta,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El numero de cuenta esta vacio.';

		   SELECT   Par_NumErr 		        AS CodigoResp,
					Par_ErrMen	            AS CodigoDesc,
					'false' 				AS EsValido,
					Aut_Fecha				AS AutFecha,
					'0'				 		AS FolioAut,
					'0.00' 					AS SaldoTot,
					'0.00' 					AS SaldoDisp;
		LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'El monto es cero.';

			SELECT   Par_NumErr 		        AS CodigoResp,
				Par_ErrMen	            AS CodigoDesc,
				'false' 				AS EsValido,
				Aut_Fecha				AS AutFecha,
				'0'				 		AS FolioAut,
				'0.00' 					AS SaldoTot,
				'0.00' 					AS SaldoDisp;
				LEAVE ManejoErrores;
		END IF;




		IF(Par_NumCon = Con_GrupoNoSoLiWS) THEN


			IF NOT EXISTS (SELECT CuentaAhoID
								FROM CUENTASAHO Cue,
									CLIENTES Cli,
									 INTEGRAGRUPONOSOL Gru
								WHERE Cue.CuentaAhoID = Par_Num_Cta
									AND Cli.ClienteID = Par_Num_Socio
									AND Cue.ClienteID = Cli.ClienteID
									AND Cli.Estatus = Estatus_Activo
									AND Cli.ClienteID = Gru.ClienteID
									AND Gru.ClienteID =  Par_Num_Socio
								AND Cue.Estatus = Estatus_Activo)THEN
				   LEAVE ManejoErrores;
			END IF;
		END IF;




		IF(Par_NumCon = Con_PromotorWS) THEN

			SET Var_Promotor := (SELECT PromotorID
									FROM PROMOTORES Pro
									INNER JOIN USUARIOS Usu	ON Usu.UsuarioID = Pro.UsuarioID
										WHERE Usu.Clave = Par_Id_Usuario
											AND Usu.Contrasenia = Par_Clave);

	         IF NOT EXISTS(SELECT Cli.PromotorActual
								FROM PROMOTORES Pro
								INNER JOIN CLIENTES Cli	ON Cli.PromotorActual = Pro.PromotorID
									WHERE PromotorActual = Var_Promotor
										AND Cli.ClienteID = Par_Num_Socio)THEN
							LEAVE ManejoErrores;
			END IF;


			IF NOT EXISTS (SELECT CuentaAhoID
						FROM CUENTASAHO Cue,
							 CLIENTES Cli
						 WHERE Cue.CuentaAhoID = Par_Num_Cta
							AND Cli.ClienteID = Par_Num_Socio
							AND Cue.ClienteID = Cli.ClienteID
							AND Cli.Estatus = Estatus_Activo
							AND Cue.Estatus = Estatus_Activo)THEN
						LEAVE ManejoErrores;
					END IF;
		END IF;


		SET Var_FechaSis	:=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_DescripcionMov	:= (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = TipoMov);
		SET Var_MonedaID	:= (SELECT MonedaID FROM CUENTASAHO WHERE CuentaAhoID = Par_Num_Cta);
		SET Var_SucurCli	:= (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Par_Num_Socio);

		CALL CONTAAHORROPRO(Par_Num_Cta,		Par_Num_Socio,		Aud_NumTransaccion,		Var_FechaSis,		Var_FechaSis,
							NatMovimiento,		Par_Monto,		 	Var_DescripcionMov,		Par_Num_Cta,		TipoMov,
							Var_MonedaID,		Var_SucurCli,		AltaEncPoliza,			ConceptoConta,		Var_poliza,
							AltaPoliza,			ConceptoAho,		NatMovConta,			Var_NumErr,			Var_MenErr,
							Entero_Cero,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SELECT Usu.UsuarioId, Usu.SucursalUsuario, CajaID
			FROM CAJASVENTANILLA Ven,
				 USUARIOS Usu
				WHERE Ven.UsuarioID = Usu.UsuarioID
					AND Ven.Estatus = Estatus_Activo
					AND Usu.Clave= Par_Id_Usuario
					AND Usu.Contrasenia = Par_Clave
				LIMIT 1
			INTO Var_UsuarioID, Var_SucursalID, Var_CajaID;

		SET Entero_Cero := 0;


		CALL CAJASMOVSALT(
						   Var_SucursalID, 	   Var_CajaID, 	    Var_FechaSis, 		Aud_NumTransaccion, 	Var_MonedaID,
						   Par_Monto,			Decimal_Cero,	TipoOperacion,		Var_CajaID,				Par_Num_Cta,
						   Decimal_Cero,		Decimal_Cero,	Salida_NO,			Var_NumErr, 			Var_MenErr,
						   Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
						   Aud_Sucursal,		Aud_NumTransaccion);


		IF(IFNULL(Var_NumErr, Entero_Cero) != Entero_Cero) THEN
			SET Par_NumErr := 7;
			SET Par_ErrMen := 'Error al realizar movimiento en caja.';
			SELECT  Par_NumErr 		        AS CodigoResp,
					Par_ErrMen	            AS CodigoDesc,
					'false' 				AS EsValido,
					Aut_Fecha				AS AutFecha,
					'0'				 		AS FolioAut,
					'0.00' 					AS SaldoTot,
					'0.00' 					AS SaldoDisp;
				LEAVE ManejoErrores;
		END IF;

		SET TipoOperacion := 21;
		CALL CAJASMOVSALT(
				Var_SucursalID, 		Var_CajaID, 		Var_FechaSis, 		Aud_NumTransaccion, 	Var_MonedaID,
				Par_Monto,				Decimal_Cero,		TipoOperacion,		Var_CajaID,				Par_Num_Cta,
				Decimal_Cero,			Decimal_Cero,		Salida_NO,			Var_NumErr, 			Var_MenErr,
				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);

		IF(IFNULL(Var_NumErr, Entero_Cero) != Entero_Cero) THEN
			SET Par_NumErr := 8;
			SET Par_ErrMen := 'Error al realizar movimiento en caja.';
			SELECT  Par_NumErr 		        AS CodigoResp,
					Par_ErrMen	            AS CodigoDesc,
					'false' 				AS EsValido,
					Aut_Fecha				AS AutFecha,
					'0'				 		AS FolioAut,
					'0.00' 					AS SaldoTot,
					'0.00' 					AS SaldoDisp;
				LEAVE ManejoErrores;
		END IF;


		SET AltaEncPoliza  := 'N';
		CALL DENOMINAMOVSALT(
						Var_SucursalID, 		Var_CajaID,			Var_FechaSis, 			Aud_NumTransaccion, 		NatMovi,
						DenominacionID,		    Par_Monto, 			Par_Monto,				Var_MonedaID,			    AltaEncPoliza,
						Var_CajaID,				Par_Num_Cta,		Salida_NO, 				Par_EmpresaID, 				DesMovCaja,
						Par_Num_Socio,			Var_Poliza,			Var_NumErr, 			Var_MenErr,					Entero_Cero,
						Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,
						Aud_NumTransaccion);
		SET Entero_Cero := 0;

		IF(IFNULL(Var_NumErr, Entero_Cero) != Entero_Cero) THEN
			SET Par_NumErr := 9;
			SET Par_ErrMen := 'Error en la denominacion.';

			SELECT      Par_NumErr 		        AS CodigoResp,
						Par_ErrMen	            AS CodigoDesc,
						'false' 				AS EsValido,
						Aut_Fecha				AS AutFecha,
						'0'				 		AS FolioAut,
						'0.00' 					AS SaldoTot,
						'0.00' 					AS SaldoDisp;
			LEAVE ManejoErrores;
		END IF;


		SELECT IFNULL(Saldo,Decimal_Cero), IFNULL(SaldoDispon,Decimal_Cero)
			FROM CUENTASAHO WHERE CuentaAhoID = Par_Num_Cta
			INTO   Var_Saldo, Var_SaldoDisp;

		SELECT  '1'						AS CodigoResp,
				'Transaccion Aceptada' 	AS CodigoDesc,
				'true' 					AS EsValido,
				Aut_Fecha				AS AutFecha,
				Aud_NumTransaccion 		AS FolioAut,
				Var_Saldo				AS SaldoTot,
				Var_SaldoDisp			AS SaldoDisp;
	ELSE

		SELECT		Caj.CajaID,	Caj.EstatusOpera,	Usu.RolID,	Usu.Estatus
			into	Var_CajaID, Var_EstatusCaja,	Var_RolFR,	Var_EstatusUsuario
			FROM 	USUARIOS Usu,
					PARAMETROSCAJA Par,
					 CAJASVENTANILLA Caj
						WHERE Usu.Clave			= Par_Id_Usuario
							AND Usu.Contrasenia = Par_Clave
							AND Usu.UsuarioID	= Caj.UsuarioID;

		SET Var_CajaID			:= ifnull(Var_CajaID, 0);
		SET Var_EstatusCaja		:= ifnull(Var_EstatusCaja, '');
		SET Var_RolFR			:= ifnull(Var_RolFR, 0);
		SET Var_EstatusUsuario	:= ifnull(Var_EstatusUsuario, '');
		SET Par_NumErr := 2;
		SET Par_ErrMen := concat('Usuario y/o Contrasenia incorrectos.|  Caja: ',Var_CajaID, ' con estatus de operacion: ',Var_EstatusCaja, '  | El Rol del Usuario es: ',Var_RolFR , ' | con estatus: ',Var_EstatusUsuario );

		SELECT  Par_NumErr 			    AS CodigoResp,
				Par_ErrMen              AS CodigoDesc,
				'false' 				AS EsValido,
				Aut_Fecha				AS AutFecha,
				'0'				 		AS FolioAut,
				'0.00' 					AS SaldoTot,
				'0.00' 					AS SaldoDisp;
	END IF;

END ManejoErrores;

END TerminaStore$$