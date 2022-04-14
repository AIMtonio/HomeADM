-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAGARLIQPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAGARLIQPRO`;
DELIMITER $$

CREATE PROCEDURE `CONTAGARLIQPRO`(
	Par_Poliza				BIGINT,
	Par_FechaAplicacion		DATE,
	Par_ClienteID			INT,
	Par_CuentaAhoID			BIGINT(12),

	Par_MonedaID			INT,			-- ID de la Moneda
	Par_CantidadMov			DECIMAL(12,2),	-- Cantidad del movimiento
	Par_AltaEnPol			CHAR(1),
	Par_ConceptoCon			INT(11),
	Par_EsDepGL				CHAR(1),		-- Se especifica si es deposito o devolucion de garantia Liquida

	Par_TipoBloq			INT(11),
	Par_DescripcionMov		VARCHAR(200),
    Par_Salida              CHAR(1),
	INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

	-- Parametros de Auditoria
	Par_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE	Var_Cargos			DECIMAL(12,2);
DECLARE	Var_Abonos			DECIMAL(12,2);
DECLARE Var_CuentaStr		VARCHAR(20);
DECLARE Var_GeneraPol		CHAR(1);
DECLARE Var_Control       	VARCHAR(100);

-- DECLARACION DE CONSTANTES
DECLARE Entero_Cero 		INT(11);
DECLARE GeneraSI			CHAR(1);
DECLARE Nat_Cargo			CHAR(1);
DECLARE Nat_Abono			CHAR(1);
DECLARE AltaEnPolSi			CHAR(1);
DECLARE	Pol_Automatica		CHAR(1);
DECLARE Salida_NO			CHAR(1);
DECLARE SalidaSI			CHAR(1);
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE DescripcionMov		VARCHAR(150);	-- Descripcion del movimiento
DECLARE Bloq_GL				INT(11);
DECLARE DepGL				CHAR(1);
DECLARE BloqGar				INT(11);
DECLARE DevGL				CHAR(1);
DECLARE ConceptoAhorro		INT(11);
DECLARE ConceptoAhoGL		INT(11);
DECLARE ConceptoGarFOGAFI	INT(11);
DECLARE ConceptoAhoPasivo	INT(11);
DECLARE DescEncabezado		VARCHAR(200);
DECLARE DescripBlo			VARCHAR(200);
DECLARE DesVentanilla       VARCHAR(50);
DECLARE BloqGarFOGAFI		INT(11);

-- ASIGNACION DE CONSTANTES
SET Entero_Cero				:= 0;
SET GeneraSI				:= 'S';
SET	Nat_Cargo				:= 'C';
SET	Nat_Abono				:= 'A';
SET AltaEnPolSi				:= 'S';
SET	Pol_Automatica			:= 'A';
SET	Salida_NO				:= 'N';
SET	SalidaSI				:= 'S';
SET	Decimal_Cero			:= 0.0;
SET Bloq_GL					:= 8;
SET DepGL					:='D';
SET BloqGar					:= 8;
SET DevGL					:='V';
SET ConceptoAhoGL			:=30;		-- Concepto de ahorro, tabla: CONCEPTOSAHORRO, es de Garanta Liquida
SET ConceptoAhoPasivo		:=1;		-- Concepto de ahorro, tabla: CONCEPTOSAHORRO, es de pasivo
SET DesVentanilla           :='DEVOLUCION GARANTIA LIQUIDA';
SET BloqGarFOGAFI			:= 20;		-- TIpo de Bloqueo FOGAFI
SET ConceptoGarFOGAFI		:= 32;		-- Concepto de ahorro, tabla: CONCEPTOSAHORRO, es de Garantia Financiada

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
            SET Par_NumErr = 999;
      		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                 				 'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTAGARLIQPRO');
      		SET Var_Control = 'SQLEXCEPTION';
        END;


	SET Aud_FechaActual 	:= NOW();

	IF (Par_ClienteID <= 0)THEN
		SET Par_ClienteID	:= (SELECT  ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);
	END IF;

	SELECT ContabilidadGL INTO Var_GeneraPol FROM  PARAMETROSSIS;

	IF(Var_GeneraPol=GeneraSI AND (Par_TipoBloq = BloqGar OR Par_TipoBloq = BloqGarFOGAFI) AND Par_DescripcionMov <> DesVentanilla)THEN

        -- Si valida si el movimiento es de Garantía Financiada, se cambia el Concepto de Ahorro para los movimientos contables
        IF(Par_TipoBloq = BloqGarFOGAFI) THEN
			-- Si el tipo de bloqueo es garantia Financiada, el concepto de ahorro será por garantia financiada
			SET ConceptoAhorro := ConceptoGarFOGAFI;
		ELSE
			-- Si el tipo de bloqueo es garantia líquida, el concepto de ahorro será por garantia líquida
			SET ConceptoAhorro := ConceptoAhoGL;
		END IF;

		IF(Par_EsDepGL=DepGL)THEN
			IF(Par_AltaEnPol=AltaEnPolSi)THEN
				CALL MAESTROPOLIZASALT(
					Par_Poliza,			Par_Empresa,   		Par_FechaAplicacion, 	Pol_Automatica,	Par_ConceptoCon,
					Par_DescripcionMov,	Salida_NO,      	Par_NumErr,				Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

			SET Var_CuentaStr 	:= CONCAT("Cta.",CONVERT(Par_CuentaAhoID, CHAR));

			CALL POLIZASAHORROPRO(
				Par_Poliza,         Par_Empresa,    		Par_FechaAplicacion,	Par_ClienteID,	    ConceptoAhoPasivo,
				Par_CuentaAhoID,    Par_MonedaID,   		Par_CantidadMov,        Decimal_Cero,		Par_DescripcionMov,
				Var_CuentaStr,		Salida_NO,      		Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL POLIZASAHORROPRO(
				Par_Poliza,         Par_Empresa,    		Par_FechaAplicacion,	Par_ClienteID,	    ConceptoAhorro,
				Par_CuentaAhoID,    Par_MonedaID,   		Decimal_Cero,        	Par_CantidadMov,	Par_DescripcionMov,
				Var_CuentaStr,		Salida_NO,      		Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;


		ELSE -- Deposito de GL
				IF(Par_AltaEnPol = AltaEnPolSi)THEN
					CALL MAESTROPOLIZASALT(
						Par_Poliza,			Par_Empresa,   		Par_FechaAplicacion, 	Pol_Automatica,	Par_ConceptoCon,
						Par_DescripcionMov,	Salida_NO,      	Par_NumErr,				Par_ErrMen,			Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					IF (Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

				END IF;

				SET Var_CuentaStr 	:= CONCAT("Cta.",CONVERT(Par_CuentaAhoID, CHAR));

				CALL POLIZASAHORROPRO(
					Par_Poliza,         Par_Empresa,    		Par_FechaAplicacion,	Par_ClienteID,	    ConceptoAhoPasivo,
					Par_CuentaAhoID,    Par_MonedaID,   		Decimal_Cero,        	Par_CantidadMov,	Par_DescripcionMov,
					Var_CuentaStr,		Salida_NO,      		Par_NumErr,				Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				CALL POLIZASAHORROPRO(
					Par_Poliza,         Par_Empresa,    		Par_FechaAplicacion,	Par_ClienteID,	    ConceptoAhorro,
					Par_CuentaAhoID,    Par_MonedaID,   		Par_CantidadMov,        Decimal_Cero,		Par_DescripcionMov,
					Var_CuentaStr,		Salida_NO,      		Par_NumErr,				Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

		END IF; -- ELSE Deposito de GL
	END IF; -- Si Bloquear GL

	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen  := 'Proceso Contable de Garantia Liquida realizado Exitosamente.';

END ManejoErrores;  -- END del Handler de Errores

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'cuentaAhoID' AS control,
            Par_Poliza AS consecutivo;
END IF;

END TerminaStore$$