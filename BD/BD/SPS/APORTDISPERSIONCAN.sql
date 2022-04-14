

-- APORTDISPERSIONCAN --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTDISPERSIONCAN`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------

DELIMITER $$
CREATE  PROCEDURE `APORTDISPERSIONCAN`(
/* SP DE BAJA DE DISPERSIONES EN APORTACIONES */
	Par_AportacionID			INT(11),		-- ID de Aportación.
	Par_AmortizacionID			INT(11),		-- Id de la Amortizacion.
	Par_CuentaTranID			INT(11),		-- No consecutivo de cuentas transfer por cliente.
	Par_MontoCancelar			DECIMAL(18,2),		-- Monto a Cancelar
	Par_TipoBaja				INT(11),		-- Tipo de Baja.
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error

	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),

	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control			CHAR(15);
DECLARE	Var_FechaSistema	CHAR(15);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	Cons_SI				CHAR(1);
DECLARE	Cons_NO				CHAR(1);
DECLARE	EstatusDisp			CHAR(1);
DECLARE	ActBeneficiarios	INT(11);
DECLARE	BajaDispersion		INT(11);
DECLARE	BajaBeneficiario	INT(11);
DECLARE	BajaCancelacion		INT(11);
DECLARE Var_CuentaAhoID		BIGINT(20);
DECLARE Var_MontoPendiente	DECIMAL(18,2);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia.
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero			:= 0;				-- Entero Cero.
SET	Cons_SI				:= 'S';				-- Constante Si.
SET	Cons_NO				:= 'N'; 			-- Constante No.
SET	EstatusDisp			:= 'C'; 			-- Estatus Procesada de Dispersión (Dispersada).
SET BajaDispersion		:= 1;				-- Actualizacion de beneficiarios.
SET BajaBeneficiario	:= 2;				-- Tipo de Baja por Modificación desde pantalla.
SET BajaCancelacion		:= 3;				-- Tipo de Baja por Cancelacion.
SET Aud_FechaActual 	:= NOW();
SET Var_CuentaAhoID		:= (SELECT CuentaAhoID FROM APORTACIONES WHERE  AportacionID = Par_AportacionID);
SET Var_MontoPendiente 	:= (SELECT MontoPendiente FROM APORTCTADISPERSIONES WHERE  CuentaAhoID = Var_CuentaAhoID);
SET Var_MontoPendiente  := IFNULL(Var_MontoPendiente,Entero_Cero);

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTDISPERSIONCAN');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(Par_MontoCancelar > Var_MontoPendiente) THEN 
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Monto a Cancelar es Mayor al Monto Pendiente';
			SET Var_Control:= 'aportacionID' ;
			LEAVE ManejoErrores;
	END IF;

	IF (Par_TipoBaja = bajaDispersion)THEN

			IF(Par_MontoCancelar = Var_MontoPendiente) THEN 
				
				IF EXISTS (SELECT AportacionID FROM APORTBENEFICIARIOS	WHERE AportacionID = Par_AportacionID
								AND AmortizacionID = Par_AmortizacionID
								AND CuentaTranID = Par_CuentaTranID)THEN

						INSERT INTO HISAPORTBENEFICIARIOS(
							HisBenefID,
							AportacionID,		AmortizacionID,		CuentaTranID,			InstitucionID,		TipoCuentaSpei,
							Clabe,				Beneficiario,		EsPrincipal,			MontoDispersion,	TipoBaja,
							EmpresaID,			UsuarioID,			FechaActual,			DireccionIP,		ProgramaID,
							Sucursal,			NumTransaccion)
						SELECT
							AportBeneficiarioID,
							AportacionID,		AmortizacionID,		CuentaTranID,			InstitucionID,		TipoCuentaSpei,
							Clabe,				Beneficiario,		EsPrincipal,			MontoDispersion,	BajaCancelacion,
							EmpresaID,			UsuarioID,			FechaActual,			DireccionIP,		ProgramaID,
							Sucursal,			Aud_NumTransaccion
						FROM APORTBENEFICIARIOS
						WHERE AportacionID = Par_AportacionID
							AND AmortizacionID = Par_AmortizacionID
							AND CuentaTranID = Par_CuentaTranID;


						DELETE FROM APORTBENEFICIARIOS
						WHERE AportacionID = Par_AportacionID
							AND AmortizacionID = Par_AmortizacionID
							AND CuentaTranID = Par_CuentaTranID;
				END IF;
				
				CALL HISAPORTDISPERSIONESALT(
						Par_AportacionID,	Par_AmortizacionID,	Cons_NO,			Par_NumErr,			Par_ErrMen,
						Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);
					
				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			ELSE
				
				UPDATE  APORTCTADISPERSIONES AP
					SET AP.MontoPendiente =  (AP.MontoPendiente  - Par_MontoCancelar)
				WHERE  AP.CuentaAhoID = Var_CuentaAhoID;

				SET Var_MontoPendiente 	:= (SELECT MontoPendiente FROM APORTCTADISPERSIONES WHERE  CuentaAhoID = Var_CuentaAhoID);


				UPDATE APORTDISPERSIONES AP
					SET CuentaTranID = NULL 
				WHERE AP.CuentaAhoID = Var_CuentaAhoID;


				IF EXISTS (SELECT AportacionID FROM APORTBENEFICIARIOS	WHERE AportacionID = Par_AportacionID
								AND AmortizacionID = Par_AmortizacionID
								AND CuentaTranID = Par_CuentaTranID)THEN

						INSERT INTO HISAPORTBENEFICIARIOS(
							HisBenefID,
							AportacionID,		AmortizacionID,		CuentaTranID,			InstitucionID,		TipoCuentaSpei,
							Clabe,				Beneficiario,		EsPrincipal,			MontoDispersion,	TipoBaja,
							EmpresaID,			UsuarioID,			FechaActual,			DireccionIP,		ProgramaID,
							Sucursal,			NumTransaccion)
						SELECT
							AportBeneficiarioID,
							AportacionID,		AmortizacionID,		CuentaTranID,			InstitucionID,		TipoCuentaSpei,
							Clabe,				Beneficiario,		EsPrincipal,			MontoDispersion,	BajaCancelacion,
							EmpresaID,			UsuarioID,			FechaActual,			DireccionIP,		ProgramaID,
							Sucursal,			Aud_NumTransaccion
						FROM APORTBENEFICIARIOS
						WHERE AportacionID = Par_AportacionID
							AND AmortizacionID = Par_AmortizacionID
							AND CuentaTranID = Par_CuentaTranID;


						DELETE FROM APORTBENEFICIARIOS
						WHERE AportacionID = Par_AportacionID
							AND AmortizacionID = Par_AmortizacionID
							AND CuentaTranID = Par_CuentaTranID;
				END IF;

			END IF;


    END IF;

	IF(Par_TipoBaja = bajaBeneficiario) THEN

		IF EXISTS (SELECT AportacionID FROM APORTBENEFICIARIOS	WHERE AportacionID = Par_AportacionID
				AND AmortizacionID = Par_AmortizacionID
				AND CuentaTranID = Par_CuentaTranID)THEN

			INSERT INTO HISAPORTBENEFICIARIOS(
			HisBenefID,
			AportacionID,		AmortizacionID,		CuentaTranID,			InstitucionID,		TipoCuentaSpei,
			Clabe,				Beneficiario,		EsPrincipal,			MontoDispersion,	TipoBaja,
			EmpresaID,			UsuarioID,			FechaActual,			DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion)
			SELECT
				AportBeneficiarioID,
				AportacionID,		AmortizacionID,		CuentaTranID,			InstitucionID,		TipoCuentaSpei,
				Clabe,				Beneficiario,		EsPrincipal,			MontoDispersion,	BajaCancelacion,
				EmpresaID,			UsuarioID,			FechaActual,			DireccionIP,		ProgramaID,
				Sucursal,			Aud_NumTransaccion
			FROM APORTBENEFICIARIOS
			WHERE AportacionID = Par_AportacionID
				AND AmortizacionID = Par_AmortizacionID
				AND CuentaTranID = Par_CuentaTranID;

			DELETE FROM APORTBENEFICIARIOS
			WHERE AportacionID = Par_AportacionID
				AND AmortizacionID = Par_AmortizacionID
				AND CuentaTranID = Par_CuentaTranID;

		END IF;


    END IF;


	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Dispersion Cancelada Exitosamente.';
	SET Var_Control:= 'aportacionID' ;

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_AportacionID AS Consecutivo;
END IF;

END TerminaStore$$