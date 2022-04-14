-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWINVGARANTIACIEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWINVGARANTIACIEPRO`;

DELIMITER $$
CREATE PROCEDURE `CRWINVGARANTIACIEPRO`(
	/* SP CIERRE DE DIA DE INVERSION DE GARANTIAS*/
	Par_Fecha				DATE,					-- PARAMETRO FECHA
	Par_Salida				CHAR(1),				-- PARAMETRO DE SALIDA
	INOUT Par_NumErr		INT(11),				-- NUMERO DE ERROR
	INOUT Par_ErrMen		VARCHAR(400),			-- MENSAJE DE ERROR

	Aud_EmpresaID			INT(11),				-- AUDITORIA
	Aud_Usuario				INT(11),				-- AUDITORIA
	Aud_FechaActual			DATETIME,				-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),			-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),			-- AUDITORIA
	Aud_Sucursal			INT(11),				-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)				-- AUDITORIA
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_TipoGarantia		CHAR(1);
DECLARE Var_CreditoID			BIGINT(12);
DECLARE Var_AplicaCapital		CHAR;
DECLARE Var_AplicaInteres		CHAR;
DECLARE Var_DiasApliGarantia	INT(3);
DECLARE	Var_FechaBatch			DATE;
DECLARE	Var_FecBitaco 			DATETIME;
DECLARE	Var_MinutosBit 			INT(11);
DECLARE Var_Aplicar				DECIMAL(14,2);
DECLARE Var_Control				VARCHAR(80);
DECLARE Var_TotalRegs			INT(11);
DECLARE Var_Contador			INT(11);

-- Declarqacion de Constantes
DECLARE Entero_Cero			INT(11);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE AltaEncPolizaSI		CHAR(1);
DECLARE SalidaNO			CHAR(1);
DECLARE Pro_AplicaGarantia	INT(11);
DECLARE	Fecha_Vacia			DATE;
DECLARE StringSI			CHAR(1);
DECLARE StringNO			CHAR(1);
DECLARE AplicaInteres		CHAR(1);
DECLARE AplicaCapital		CHAR(1);
DECLARE AplicaAmbos			CHAR(1);
DECLARE EstatusVigente		CHAR(1);
DECLARE EstatusVencido		CHAR(1);
DECLARE EstatusAtrasado		CHAR(1);
DECLARE MinimoPago			DECIMAL(12,2);

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWFONDEOPRO');
		SET Var_Control:= 'sqlException' ;
	END;

	# Se agrega para que no se ejecute el SP en el Cierre de Dia.
	LEAVE ManejoErrores;

	-- Asignacion de Constantes
	SET Entero_Cero				:=0;				-- Entero Cero
	SET Cadena_Vacia			:='';				-- Cadena Vacia
	SET AltaEncPolizaSI			:='S';				-- Alta en Encabezado de la Poliza SI
	SET SalidaNO				:='N';				-- Salida en Pantalla NO
	SET Pro_AplicaGarantia		:= 305;				-- Proceso para la Aplicación de Garantias
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET StringSI				:='S';				-- Constante SI
	SET StringNO				:='N';				-- Constante NO
	SET AplicaInteres			:='I';				-- Aplicacion de Garantias de Interes
	SET AplicaCapital			:='C';				-- Aplicacion de Garantias de Capital
	SET AplicaAmbos				:='A';				-- Aplicacion de Garantuia Capital e interes
	SET EstatusVigente			:='V';				-- Estatus Vigente
	SET EstatusVencido			:='B';				-- Estatus Vencido
	SET EstatusAtrasado			:='A';				-- Estatus Atrasado
	SET MinimoPago				:=0.01;				-- Minimo de pago


	SELECT 	DiasAplicaGarantia, 	TipoGarantia
	INTO 	Var_DiasApliGarantia, 	Var_TipoGarantia
	FROM PARAMETROSSIS LIMIT 1;

	SET Var_DiasApliGarantia := IFNULL(Var_DiasApliGarantia, Entero_Cero );
	SET Var_TipoGarantia	 := IFNULL(Var_TipoGarantia, Cadena_Vacia );

	SELECT Fecha INTO Var_FechaBatch
			FROM BITACORABATCH
			WHERE Fecha 			= Par_Fecha
			  AND ProcesoBatchID	= Pro_AplicaGarantia;

	SET Var_FechaBatch := IFNULL(Var_FechaBatch, Fecha_Vacia);

	IF Var_FechaBatch != Fecha_Vacia THEN
		LEAVE TerminaStore;
	END IF;

	SET Var_FecBitaco 		:= NOW();
	SET Aud_FechaActual		:= NOW();


	DELETE FROM TMPCREDATRASADOS WHERE NumTransaccion = Aud_NumTransaccion;

	IF(Var_DiasApliGarantia > Entero_Cero)THEN

		-- almacenamos creditos con dias de atraso

		SET @Var_ConsID := Entero_Cero;

		INSERT INTO TMPCREDATRASADOS(
			TmpID,
			FechaExigible, 		 TotalAplicar, 		 CreditoID,  		 EmpresaID,			Usuario,
			FechaActual,   		 DireccionIP,  		 ProgramaID, 		 Sucursal,			NumTransaccion)
		SELECT
			(@Var_ConsID := @Var_ConsID + 1),
			IFNULL(MIN(FechaExigible), Par_Fecha)AS FechaExigible,
							SUM(amo.SaldoCapVigente) + SUM(amo.SaldoCapAtrasa) + SUM(SaldoCapVencido)+
							SUM(amo.SaldoCapVenNExi)+ SUM(amo.SaldoInteresOrd) + SUM(SaldoInteresAtr)+
							SUM(SaldoInteresVen) + SUM(SaldoInteresPro) + SUM(SaldoIntNoConta) AS TotalAplicar,
							CreditoID,
							Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM AMORTICREDITO amo
					WHERE FechaExigible 		<= Par_Fecha
						AND (amo.Estatus		=  EstatusVigente
						OR	amo.Estatus			=  EstatusAtrasado
						OR	amo.Estatus			=  EstatusVencido)
						GROUP BY CreditoID;

		IF(IFNULL(Var_TipoGarantia,	Cadena_Vacia) = AplicaAmbos)THEN
			SET Var_AplicaCapital 	:=StringSI;
			SET Var_AplicaInteres	:=StringSI;
		ELSEIF(IFNULL(Var_TipoGarantia,Cadena_Vacia) = AplicaInteres)THEN
			SET Var_AplicaCapital 	:=StringNO;
			SET Var_AplicaInteres	:=StringSI;
		ELSEIF(IFNULL(Var_TipoGarantia,Cadena_Vacia) = AplicaCapital)THEN
			SET Var_AplicaCapital 	:=StringSI;
			SET Var_AplicaInteres	:=StringNO;
		END IF;

		SET Var_TotalRegs := (SELECT COUNT(*) FROM TMPCREDATRASADOS WHERE NumTransaccion = Aud_NumTransaccion);
		SET Var_TotalRegs := IFNULL(Var_TotalRegs, Entero_Cero);

		SET Var_Contador := 1;

		WHILE(Var_Contador <= Var_TotalRegs)DO

			SELECT 	TotalAplicar,		CreditoID
			INTO	Var_Aplicar,		Var_CreditoID
			FROM TMPCREDATRASADOS
			WHERE FechaExigible 		<= 	Par_Fecha
				AND TmpID 				= 	Var_Contador
				AND NumTransaccion 		= 	Aud_NumTransaccion;

			IF(Var_Aplicar > MinimoPago)THEN
				CALL CRWFONDEOAPGPRO(
					Var_CreditoID,		Var_AplicaCapital,	Var_AplicaInteres,	AltaEncPolizaSI,	Entero_Cero,	SalidaNO,
					Par_NumErr, 		Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Var_Contador := Var_Contador + 1;

		END WHILE;

	END IF;

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(
		Pro_AplicaGarantia, 	Par_Fecha, 			Var_MinutosBit,	Aud_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

	 -- Truncamos la tabla temporal de Paso
	DELETE FROM TMPCREDATRASADOS WHERE NumTransaccion = Aud_NumTransaccion;

	SET Par_NumErr 		:= '000';
	SET Par_ErrMen 		:= 'Cierre de Dia de Inversion de Garantias Exitoso.';

END ManejoErrores;

IF (Par_Salida = StringSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Cadena_Vacia AS Control,
			Aud_NumTransaccion AS Consecutivo;
END IF;

END TerminaStore$$
