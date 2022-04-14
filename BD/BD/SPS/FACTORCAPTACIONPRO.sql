-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTORCAPTACIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTORCAPTACIONPRO`;DELIMITER $$

CREATE PROCEDURE `FACTORCAPTACIONPRO`(
# ====================================================================
# -------SP ENCARGADO DE CALCULAR LOS FACTORES--------
# ====================================================================
	Par_Fecha			DATE,			-- Fecha de Operacion
    Par_Salida			CHAR(1),		-- Tipo de Salida.
    INOUT Par_NumErr	INT(11),		-- Numero de Error.
    INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de Error.

	Par_EmpresaID		INT(11),		-- Parametro de Auditoria
	Aud_Usuario			INT(11),		-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal		INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de Auditoria
				)
TerminaStore : BEGIN

-- Declaracion de Variables
DECLARE Var_FecBitaco		DATETIME;   -- Fecha de Inicio para la Bitacora Batch
DECLARE Var_MinutosBit		INT;		-- Almacena los minutos que tardo el Proceso
DECLARE Var_Control		VARCHAR(50);	-- Control ID

-- Declaracion de Constantes
DECLARE EnteroCero		INT(1);
DECLARE DecimalCero		DECIMAL(12,2);
DECLARE FechaVacia		DATE;
DECLARE SalidaSI		CHAR(1);
DECLARE EstInveVigente	CHAR(1);
DECLARE CalcClienteISR	CHAR(1);
DECLARE EstCtasActivas	CHAR(1);
DECLARE EstCedeVigente	CHAR(1);
DECLARE GenInteresSI	CHAR(1);
DECLARE UnDiaHabil		INT(11);
DECLARE	SigDiaHabil		DATE;
DECLARE EsHabil			CHAR(1);
DECLARE DiasCalculo		INT(11);
DECLARE DiaRegistro		DATE;
DECLARE InsAhorro		INT(11);
DECLARE InsInversion	INT(11);
DECLARE InsCede			INT(11);
DECLARE Esta_Pendiente	CHAR(1);
DECLARE Var_FinMes		DATE;
DECLARE ProcesoFactorCapta		INT(11);
DECLARE Entero_Uno      INT(11);
DECLARE Fecha_Vacia	   	DATE;

-- Asignacion de Constantes
SET EnteroCero			:=	0;					-- Entero en cero
SET DecimalCero			:=	0.00;				-- Decimal en cero
SET FechaVacia			:=	'1900-01-01';		-- Fecha Vacia
SET SalidaSI			:=	'S';				-- El Store si regresa una Salida
SET	EstInveVigente		:=	'N';				-- Estatus Vigente Inversion
SET	CalcClienteISR		:=	'C';				-- Calculo de ISR por CLIENTE (¿?)
SET EstCtasActivas		:=	'A';				-- Estatus de la Cuenta Activo
SET EstCedeVigente		:=	'N';				-- Estatus de la Cede Vigente
SET GenInteresSI		:=	'S';				-- Genera Intereses Cuenta
SET UnDiaHabil			:= 	1;					-- Un dia habil
SET InsAhorro			:=	2;					-- Instrumento de CUENTA AHORRO
SET InsInversion		:=	13;					-- Instrumento de INVERSION PLAZO
SET InsCede				:=	28;					-- Instrumento de CEDE
SET Esta_Pendiente		:=	'P';				-- EstatusPendiente
SET Var_FinMes			:= LAST_DAY(Par_Fecha);	-- Fecha de Fin de Mes
SET ProcesoFactorCapta	:= 1103;				-- Proceso Batch para la Generacion del Factor de Captacion por Cliente para el Calculo del ISR.
SET Entero_Uno     		:= 1;					-- Entero en uno
SET Fecha_Vacia     	:= '1900-01-01';    	-- Fecha Vacia

ManejoErrores : BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:=	999;
			SET Par_ErrMen	:=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-FACTORCAPTACIONPRO');
            SET Var_Control := 'sqlException';
		END;

    -- ====================== SE TRUNCAN LAS TABLAS DE TOTALES Y FACTORES ======================

        SET Var_FecBitaco	:= NOW(); -- Para Obtener la Fecha Exacta de Inicio

        DELETE FROM TOTALPRODUCTOS
			WHERE Fecha >= Par_Fecha;

        DELETE FROM TOTALCAPTACION
			WHERE Fecha >= Par_Fecha;

		DELETE FROM FACTORINVERSION
			WHERE Fecha >= Par_Fecha;

        DELETE FROM FACTORAHORRO
			WHERE Fecha >= Par_Fecha;

        DELETE FROM FACTORCEDES
			WHERE Fecha >= Par_Fecha;

    -- ====================== VERIFICAR QUE SI EL DIA SIGUIENTE ES HABIL ======================

		CALL DIASFESTIVOSCAL(Par_Fecha,				UnDiaHabil,			SigDiaHabil,		EsHabil,		Par_EmpresaID,
							 Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
							 Aud_NumTransaccion);

        SET DiaRegistro	= Par_Fecha;

     -- ====================== MIENTRAS LA FECHA SEA MENOR QUE EL DIA HABIL SIGUIENTE ======================

		WHILE (DiaRegistro < SigDiaHabil) DO

            -- INVERSIONES
				INSERT INTO FACTORINVERSION(
						Fecha,				ClienteID,		InversionID,		Capital,			TotalCaptacion,
						Factor,				Estatus,		EmpresaID,			Usuario,			FechaActual,
						DireccionIP,		ProgramaID,		Sucursal,			NumTransaccion)
				SELECT	DiaRegistro,		inv.ClienteID,	inv.InversionID,	inv.Monto,			DecimalCero,
						inv.Monto,			Esta_Pendiente,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
					FROM INVERSIONES inv
					WHERE 	inv.Estatus = EstInveVigente AND
							inv.FechaVencimiento > DiaRegistro;

			-- CEDES
				INSERT INTO FACTORCEDES(
						Fecha,	ClienteID,		CedeID,				Capital,			TotalCaptacion,
						Factor,			Estatus,EmpresaID,		Usuario,			FechaActual,		DireccionIP,
						ProgramaID,		Sucursal,		NumTransaccion)
				SELECT	DiaRegistro,	cede.ClienteID,	cede.CedeID,		cede.Monto,			DecimalCero,
						cede.Monto,		Esta_Pendiente,Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
					FROM CEDES cede
					WHERE cede.Estatus = EstCedeVigente
						AND cede.FechaVencimiento > DiaRegistro;

			-- CUENTAS
				INSERT INTO FACTORAHORRO(
						Fecha,			ClienteID,		CuentaAhoID,		Saldo,				TotalCaptacion,
						Factor,			Estatus,		EmpresaID,			Usuario,			FechaActual,
						DireccionIP,	ProgramaID,		Sucursal,			NumTransaccion)
				SELECT	DiaRegistro,	cta.ClienteID,	cta.CuentaAhoID,	cta.Saldo,			DecimalCero,
						cta.saldo,		Esta_Pendiente,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
					FROM CUENTASAHO cta
						INNER JOIN TIPOSCUENTAS tipo ON cta.TipoCuentaID = tipo.TipoCuentaID AND tipo.GeneraInteres = GenInteresSI
					WHERE 	cta.Estatus = EstCtasActivas
							AND cta.Saldo > EnteroCero;

     -- ====================== SE OBTIENE EL TOTAL DE PRODUCTOS POR CLIENTE ======================

				INSERT INTO TOTALPRODUCTOS(
						Fecha,				ClienteID,			InstrumentoID,		Total,
						EmpresaID,			Usuario,			FechaActual,		DireccionIP,	ProgramaID,
						Sucursal,           NumTransaccion)

				SELECT	DiaRegistro,		ClienteID,			InsAhorro,			SUM(Saldo),
						Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion
					FROM FACTORAHORRO
					WHERE Fecha = DiaRegistro
					GROUP BY ClienteID;

				INSERT INTO TOTALPRODUCTOS(
						Fecha,				ClienteID,			InstrumentoID,		Total,			EmpresaID,
						Usuario,			FechaActual,		DireccionIP,		ProgramaID,		Sucursal,
						NumTransaccion)
				SELECT	DiaRegistro,		ClienteID,			InsInversion,		SUM(Capital),	Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
						Aud_NumTransaccion
					FROM FACTORINVERSION
					WHERE Fecha = DiaRegistro
					GROUP BY ClienteID;

				INSERT INTO TOTALPRODUCTOS(
						Fecha,				ClienteID,			InstrumentoID,		Total,			EmpresaID,
						Usuario,			FechaActual,		DireccionIP,		ProgramaID,		Sucursal,
						NumTransaccion)
				SELECT	DiaRegistro,		ClienteID,			InsCede,			SUM(Capital),	Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
						Aud_NumTransaccion
					FROM FACTORCEDES
					WHERE Fecha = DiaRegistro
					GROUP BY ClienteID;

				INSERT INTO TOTALCAPTACION(
						Fecha,				ClienteID,			TotalCaptacion, Estatus,		EmpresaID,		Usuario,
						FechaActual,		DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
				SELECT	DiaRegistro,		ClienteID,			SUM(Total),		'P',Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
					FROM TOTALPRODUCTOS
					WHERE Fecha = DiaRegistro
					GROUP BY ClienteID;

    -- ====================== SE CALCULAN LOS FACTORES ======================

				UPDATE FACTORAHORRO aho
					INNER JOIN TOTALCAPTACION tc ON aho.ClienteID = tc.ClienteID AND aho.Fecha =tc.Fecha
						SET	aho.TotalCaptacion	=	tc.TotalCaptacion,
							aho.Factor			=	IF(IFNULL(tc.TotalCaptacion, EnteroCero) != EnteroCero, (aho.Saldo/tc.TotalCaptacion), EnteroCero)
					WHERE aho.Fecha = DiaRegistro;

				UPDATE FACTORINVERSION inv
					INNER JOIN TOTALCAPTACION tc ON inv.ClienteID = tc.ClienteID AND inv.Fecha =tc.Fecha
						SET	inv.TotalCaptacion	=	tc.TotalCaptacion,
							inv.Factor			=	IF(IFNULL(tc.TotalCaptacion, EnteroCero) != EnteroCero, (inv.Capital/tc.TotalCaptacion), EnteroCero)
					WHERE inv.Fecha = DiaRegistro;

				UPDATE FACTORCEDES cede
					INNER JOIN TOTALCAPTACION tc ON cede.ClienteID = tc.ClienteID AND cede.Fecha =tc.Fecha
						SET	cede.TotalCaptacion	=	tc.TotalCaptacion,
							cede.Factor			=	IF(IFNULL(tc.TotalCaptacion, EnteroCero) != EnteroCero, (cede.Capital/tc.TotalCaptacion), EnteroCero)
					WHERE cede.Fecha = DiaRegistro;


				DELETE FROM TOTALPRODUCTOS
					WHERE Fecha >= DiaRegistro;

				  SET	DiaRegistro	= ADDDATE(DiaRegistro, 1);
		END WHILE;


        SET Par_NumErr 	:= EnteroCero;
		SET Par_ErrMen	:= 'Calculo de Factor Realizado Exitosamente.';

        SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
        SET Aud_FechaActual	:= NOW();

		CALL BITACORABATCHALT(
			ProcesoFactorCapta,		Par_Fecha,      		Var_MinutosBit,
            Par_EmpresaID,    		Aud_Usuario,			Aud_FechaActual,
            Aud_DireccionIP,  		Aud_ProgramaID,   		Aud_Sucursal,
            Aud_NumTransaccion);

		IF(Par_NumErr <> EnteroCero)THEN
				LEAVE ManejoErrores;
		END IF;

END ManejoErrores;
	IF (Par_Salida = SalidaSI) THEN
			SELECT 	Par_NumErr	AS NumErr,
					Par_ErrMen	AS ErrMen,
                    Var_Control AS Control;
	END IF;
END TerminaStore$$