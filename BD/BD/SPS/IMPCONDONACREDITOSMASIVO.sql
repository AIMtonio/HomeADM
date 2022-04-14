DELIMITER ;
DROP PROCEDURE IF EXISTS IMPCONDONACREDITOSMASIVO;
DELIMITER $$
CREATE PROCEDURE `IMPCONDONACREDITOSMASIVO`(
	Par_Empresa			INT(11),

	Par_Salida			CHAR(1),
	INOUT	Par_NumErr	INT(11),
	INOUT	Par_ErrMen	VARCHAR(400),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

)
TerminaStore:BEGIN

	DECLARE Entero_Cero 		INT(1);
	DECLARE Cadena_Vacia 		CHAR(1);
    DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE ContadoCuota		INT(11);
	DECLARE Pol_Automatica		CHAR(1);
	DECLARE ConceptoCon			INT(11);
	DECLARE ConceptoContDesc	VARCHAR(150);
	DECLARE Salida_NO			CHAR(1);
    DECLARE Salida_SI			CHAR(1);
    DECLARE Par_AltaPolizaNO	CHAR(1);

    DECLARE Par_Poliza			BIGINT(20);
	DECLARE Var_Transaccion 	INT(11);
	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_CreditoID 		BIGINT(12);
    DECLARE Var_TotCom			DECIMAL(12,2);
    DECLARE Var_MontoCom		DECIMAL(12,2);
    DECLARE Var_PorcCom			DECIMAL(12,4);
    DECLARE Var_TotMorat		DECIMAL(12,2);
    DECLARE Var_MontoMorat		DECIMAL(12,2);
    DECLARE Var_PorcMorat		DECIMAL(12,4);
    DECLARE Var_TotInt			DECIMAL(12,2);
    DECLARE Var_MontoInt		DECIMAL(12,2);
    DECLARE Var_PorcInt			DECIMAL(12,4);
    DECLARE Var_TotCap			DECIMAL(12,4);
    DECLARE Var_MontoCap		DECIMAL(12,2);
    DECLARE Var_PorcCap			DECIMAL(12,4);


	DECLARE CURSORCONDONACRE CURSOR FOR

		SELECT C.CreditoID,	C.MontoComisiones,	C.MontoMoratorios,	C.MontoInteres,	C.MontoCapital,
        ROUND(IFNULL(SUM(ROUND(A.SaldoComFaltaPa,2) + ROUND(A.SaldoOtrasComis,2)), 0),2) AS totalComisi,
        IFNULL(SUM(A.SaldoMoratorios + A.SaldoMoraVencido + A.SaldoMoraCarVen),0) AS SaldoMoratorios,
		ROUND(IFNULL(SUM(ROUND(A.SaldoInteresOrd +
											  A.SaldoInteresAtr +
											  A.SaldoInteresVen +
											  A.SaldoInteresPro +
											  A.SaldoIntNoConta,2)),0), 2) AS totalInteres,
		IFNULL(SUM(ROUND(A.SaldoCapVigente,2)	+
						  ROUND(A.SaldoCapAtrasa,2)	+
						  ROUND(A.SaldoCapVencido,2)	+
						  ROUND(A.SaldoCapVenNExi,2)),0) AS totalCapital
		FROM IMPCONDONACIONMASIVA C
        INNER JOIN AMORTICREDITO A
        ON C.CreditoID = A.CreditoID
			WHERE A.Estatus <> 'P'
           AND C.Estatus = 'N'
           GROUP BY A.CreditoID;


	SET Entero_Cero			:=0;
	SET Cadena_Vacia		:='';
    SET Decimal_Cero		:= 0.00;
	SET ContadoCuota 		:=1;
	SET Pol_Automatica		:= 'A';
	SET ConceptoCon			:= 57;
	SET ConceptoContDesc	:= 'CONDONACION DE CARTERA';
	SET Salida_NO			:= 'N';
    SET Salida_SI			:= 'S';
    SET Par_AltaPolizaNO	:= 'N';

	SELECT  '0001' AS NoMensaje,'Inicia proceso de CONDONACIONES' AS Mensaje;

	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-IMPCONDONACREDITOSMASIVO');
		END;

truncate BITACORACREQUITASCS;

	OPEN CURSORCONDONACRE;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP
			FETCH CURSORCONDONACRE INTO

			Var_CreditoID,	Var_MontoCom,	Var_MontoMorat,	Var_MontoInt,	Var_MontoCap,
            Var_TotCom,		Var_TotMorat,	Var_TotInt,		Var_TotCap;

            SET Var_MontoCom	:= IFNULL(Var_MontoCom, Decimal_Cero);
			SET Var_MontoMorat	:= IFNULL(Var_MontoMorat, Decimal_Cero);
            SET Var_MontoInt	:= IFNULL(Var_MontoInt, Decimal_Cero);
            SET Var_MontoCap	:= IFNULL(Var_MontoCap, Decimal_Cero);
            SET Var_TotCom		:= IFNULL(Var_TotCom, Decimal_Cero);
            SET Var_TotMorat	:= IFNULL(Var_TotMorat, Decimal_Cero);
            SET Var_TotInt		:= IFNULL(Var_TotInt, Decimal_Cero);
            SET Var_TotCap		:= IFNULL(Var_TotCap, Decimal_Cero);

			-- IALDANA T_14092 INICIO
			IF( Var_MontoCap != Var_TotCap ) THEN
				SET Var_MontoCap := Var_TotCap; -- Si el monto a condonar es diferente a lo que debe el cliente, obtiene el monto total
			END IF;

			IF( Var_MontoInt != Var_TotInt ) THEN
				SET Var_MontoInt := Var_TotInt;
			END IF;

			IF( Var_MontoMorat != Var_TotMorat ) THEN
				SET Var_MontoMorat := Var_TotMorat;
			END IF;

			IF (Var_MontoCom != Var_TotCom) THEN
				SET Var_MontoCom := Var_TotCom;
			END IF;

			-- IALDANA T_14092 FIN

            IF(Var_MontoCom != Decimal_Cero) THEN

				SET Var_PorcCom 	:= ROUND((Var_MontoCom/(Var_TotCom))*100,4);
            END IF;

            IF(Var_MontoMorat != Decimal_Cero) THEN

				SET Var_PorcMorat 	:= ROUND((Var_MontoMorat/(Var_TotMorat))*100,4);
            END IF;

            IF(Var_MontoInt != Decimal_Cero) THEN
				 SET Var_PorcInt 	:= ROUND((Var_MontoInt/(Var_TotInt))*100,4);
            END IF;

			IF(Var_MontoCap != Decimal_Cero) THEN
				SET Var_PorcCap 	:= ROUND((Var_MontoCap/(Var_TotCap))*100,4);
            END IF;


			UPDATE TRANSACCIONES SET
					NumeroTransaccion = NumeroTransaccion + 1;

			SET Var_Transaccion = (SELECT NumeroTransaccion	FROM TRANSACCIONES);


			CALL MAESTROPOLIZASALT(
				Par_Poliza,			Par_Empresa,		Var_FechaSistema, 	Pol_Automatica,		ConceptoCon,
				ConceptoContDesc,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Var_Transaccion);

			IF(Par_NumErr!= Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL`CREQUITASPRO`(
				Var_CreditoID,		17,					6100,				Var_FechaSistema,	Var_MontoCom,
				Var_PorcCom,    	Var_MontoMorat,    	Var_PorcMorat,		Var_MontoInt,   	Var_PorcInt,
				Var_MontoCap,    	Var_PorcCap,    	0,					0,                  Par_Poliza,
                Par_AltaPolizaNO,   Salida_NO,			Par_NumErr,    		Par_ErrMen,    		Par_Empresa,
                Aud_Usuario,    	Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,    	Aud_Sucursal,
                Var_Transaccion);

         insert into BITACORACREQUITASCS values(Var_CreditoID,Par_NumErr,Par_ErrMen );

			IF(Par_NumErr!= Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

            UPDATE IMPCONDONACIONMASIVA
            SET Estatus = 'A'
            WHERE CreditoID = Var_CreditoID;

	END LOOP;
	END;
	CLOSE CURSORCONDONACRE;

	SET Par_NumErr 	:= Entero_Cero;
	SET Par_ErrMen	:= 'Condonacion Realizada Exitosamente.';
END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
			SELECT 	Par_NumErr	AS NumErr,
					Par_ErrMen	AS ErrMen;
	END IF;

SELECT  '0004' AS NoMensaje,'Termino el proceso ' AS Mensaje;


END TerminaStore$$