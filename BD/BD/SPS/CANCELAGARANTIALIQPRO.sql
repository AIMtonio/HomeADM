-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELAGARANTIALIQPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELAGARANTIALIQPRO`;DELIMITER $$

CREATE PROCEDURE `CANCELAGARANTIALIQPRO`(
# ===========================================================
# --------- SP QUE LIBERA LA GARANTIA LIQUIDA DE UN CREDITO PARA LA CANCELACION DE UN CREDITO ---------
# ===========================================================
	Par_CreditoID			BIGINT(12),		# Numero de Credito
    Par_ClienteID			INT(11),		# Numero de Cliente
    INOUT	Par_Poliza		BIGINT,			# Numero de Poliza

	Par_Salida				CHAR(1),		# Indica Salida S:SI   N:NO
	INOUT Par_NumErr		INT(11),		# Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	# Mensaje de Error

	# Parametros de Auditoria
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

	)
TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE	Var_BloqueoID			INT(11);		-- Numero de Bloqueo
DECLARE	Var_Referencia			VARCHAR(20);	-- Numero de Referencia
DECLARE	Var_CuentaAhoID			BIGINT(12);		-- Numero de la Cuenta de Ahorro
DECLARE Var_FechaSistema  		DATE;			-- Fecha del Sistema


DECLARE	Var_RequiereContaGarLiq	CHAR(1);		-- Indica si requiere la contabilidad de la liberacion de garantia liquida
DECLARE	Var_MontoDesbloquear	DECIMAL(14,2);	-- Monto a Desbloquear
DECLARE Var_NumBloqueos			INT(11);		-- Numero de Bloqueos
DECLARE Var_Contador			INT(11);		-- Contador
DECLARE Var_Control             VARCHAR(100);	-- Variable de control
-- Variables para generar la Poliza contable en caso de que aplique
DECLARE	Var_MonedaID				INT;
DECLARE	Var_ConceptoContaDevGarLiq	INT;

-- Declaracion de Constantes
DECLARE	Entero_Cero			INT(11);
DECLARE	BloqPorGarLiq		INT(11);
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE EstatusLiquidado	CHAR(1);
DECLARE	ValorSI				CHAR(1);
DECLARE	ValorNO				CHAR(1);
DECLARE NatBloqueo			CHAR(1);
DECLARE NatDesbloqueo		CHAR(1);
DECLARE	DescripcionDesblo	VARCHAR(50);
DECLARE	DevolucionGarLiq	CHAR(1);


-- Asignacion de Constantes
SET	Entero_Cero				:= 0;				-- Constante de entero Cero
SET	BloqPorGarLiq			:= 8;				-- Constante del Tipo de Bloqueo por Garantia liquida
SET	Cadena_Vacia			:= '';				-- Constante de Cadena Vacia
SET	EstatusLiquidado		:= 'P';				-- Estatus de Credito que indica que esta pagado
SET ValorSI					:= 'S';				-- Representa el valor Si o True
SET ValorNO					:= 'N';				-- Representa el valor No o False
SET NatBloqueo 				:= 'B';				-- Naturaleza de Bloqueo en el saldo de cuenta por Garantia Liquida
SET	NatDesbloqueo			:= 'D';				-- Natauraleza de Desbloqueo en saldo de cuenta por Garantia liquida
SET	DevolucionGarLiq		:= 'V';				-- Operacion contable de Devolucion de Garantia liquida

SET	DescripcionDesblo		:= 'LIBERACION GL POR CANCELACION DE CREDITO';
SET	Var_ConceptoContaDevGarLiq		:= 62;


ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CANCELAGARANTIALIQPRO');
				SET Var_Control := 'sqlexception';
			END;

	DELETE FROM BLOQUEOSCRE
    WHERE Referencia = Par_CreditoID;
	-- Inicializacion
	SET Aud_FechaActual 	:= NOW();


	SELECT FechaSistema,		ContabilidadGL
		INTO Var_FechaSistema,	Var_RequiereContaGarLiq
		FROM PARAMETROSSIS;

	# Se llena la tabla BLOQUEOSCRE con el total de bloqueos que amparan un credito
	INSERT INTO BLOQUEOSCRE(
		Consecutivo,			BloqueoID,			CuentaAhoID,		MontoBloqueado,		Referencia,
        MonedaID,				EmpresaID,			Usuario,			FechaActual,		DireccionIP,
        ProgramaID,				Sucursal,			NumTransaccion)

    (SELECT @s:=@s+1 AS Consecutivo,		BloqueoID,			Bloq.CuentaAhoID,	Bloq.MontoBloq, 	Bloq.Referencia,
			Cue.MonedaID,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
	FROM 	BLOQUEOS Bloq
		INNER JOIN CUENTASAHO Cue	ON Bloq.CuentaAhoID = Cue.CuentaAhoID,
        (SELECT @s:= Entero_Cero) AS S
	WHERE  Bloq.TiposBloqID 		= BloqPorGarLiq
		AND	IFNULL(Bloq.FolioBloq, Entero_Cero) = Entero_Cero
		AND	Bloq.NatMovimiento 		=	NatBloqueo
		AND	Bloq.Referencia			=	Par_CreditoID);


    # Se obtiene el numero de bloqueos que amparan a un credito
	SET Var_NumBloqueos := (SELECT COUNT(Consecutivo)
							FROM BLOQUEOSCRE
							WHERE Referencia = Par_CreditoID
							AND NumTransaccion = Aud_NumTransaccion);

	SET Var_Contador := 1;
	IF(Var_NumBloqueos > Entero_Cero) THEN
		WHILE(Var_Contador <=  Var_NumBloqueos) DO
			# Se obtienen los valores del bloqueo
			SELECT    BloqueoID,		CuentaAhoID,		MontoBloqueado,			Referencia,			MonedaID
				INTO  Var_BloqueoID,	Var_CuentaAhoID,	Var_MontoDesbloquear,	Var_Referencia,		Var_MonedaID
			FROM BLOQUEOSCRE
			WHERE Referencia	    = Par_CreditoID
				AND NumTransaccion	= Aud_NumTransaccion
                AND Consecutivo = Var_Contador;


			# Se genera el debloqueo operativo
			CALL BLOQUEOSPRO(
					Var_BloqueoID,		NatDesbloqueo,		Var_CuentaAhoID,	Var_FechaSistema,	Var_MontoDesbloquear,
					Var_FechaSistema,	BloqPorGarLiq,		DescripcionDesblo,	Var_Referencia,		Cadena_Vacia,
					Cadena_Vacia,		ValorNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

			 IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_RequiereContaGarLiq = ValorSI) THEN

				# Se genera el desbloqueo contable
				CALL CONTAGARLIQPRO(
					Par_Poliza,				Var_FechaSistema,	Par_ClienteID,				Var_CuentaAhoID, 	Var_MonedaID,
					Var_MontoDesbloquear, 	ValorNO,			Var_ConceptoContaDevGarLiq,	DevolucionGarLiq,	BloqPorGarLiq,
					DescripcionDesblo,		ValorNO,			Par_NumErr,					Par_ErrMen,			Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

            SET Var_Contador := Var_Contador + 1;

		 END WHILE;
	END IF;
    DELETE FROM BLOQUEOSCRE
    WHERE Referencia = Par_CreditoID;
END ManejoErrores;  -- End del Manejo de Errores


 IF (Par_Salida = ValorSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'CreditoID' AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$