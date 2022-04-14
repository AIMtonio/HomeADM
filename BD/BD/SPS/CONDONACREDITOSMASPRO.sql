-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONDONACREDITOSMASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONDONACREDITOSMASPRO`;
DELIMITER $$


CREATE PROCEDURE `CONDONACREDITOSMASPRO`(
/*Proceso de Condonacion Masiva*/
	Par_TransaccionID				BIGINT(20),					# Numero de Transaccion con el que se hizo la carga
	Par_FechaCarga					DATE,
	Par_Salida						CHAR(1),
	INOUT	Par_NumErr				INT(11),
	INOUT	Par_ErrMen				VARCHAR(400),
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
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
    DECLARE Var_Control			VARCHAR(50);

    DECLARE Par_Poliza			BIGINT(20);
	DECLARE Var_Transaccion 	INT(11);
	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_CreditoID 		BIGINT(12);		-- Numero de Credito
    DECLARE Var_TotCom			DECIMAL(12,2);	-- Total de Adeudo de Comisiones
    DECLARE Var_MontoCom		DECIMAL(12,2);	-- Monto Comision
    DECLARE Var_PorcCom			DECIMAL(12,4);	-- Porcentaje Comision
    DECLARE Var_TotMorat		DECIMAL(12,2);	-- Total Adeudo Moratorios
    DECLARE Var_MontoMorat		DECIMAL(12,2);	-- Monto Moratorios
    DECLARE Var_PorcMorat		DECIMAL(12,4);	-- Porcentaje Moratorios
    DECLARE Var_TotInt			DECIMAL(12,2);	-- Total Adeudo Interes
    DECLARE Var_MontoInt		DECIMAL(12,2);	-- Monto Interes
    DECLARE Var_PorcInt			DECIMAL(12,4);	-- Porcentaje Interes
    DECLARE Var_TotCap			DECIMAL(12,4);	-- Total Adeudo Capital
    DECLARE Var_MontoCap		DECIMAL(12,2);	-- Monto Capital
    DECLARE Var_PorcCap			DECIMAL(12,4);	-- Porcentaje Capital
    DECLARE Var_Consecutivo		VARCHAR(50);
   DECLARE Var_PuestoID			VARCHAR(20);
  DECLARE Var_AmorticreditoID	BIGINT(20);


	DECLARE CURSORCONDONACRE CURSOR FOR

		SELECT C.CreditoID,	C.MontoComisiones,	C.MontoMoratorios,	C.MontoInteres,	C.MontoCapital,
        ROUND(IFNULL(SUM(ROUND(A.SaldoComFaltaPa,2) + ROUND(A.SaldoComServGar,2) + ROUND(A.SaldoOtrasComis,2)), 0),2) AS totalComisi,
        IFNULL(SUM(A.SaldoMoratorios + A.SaldoMoraVencido + A.SaldoMoraCarVen),0) AS SaldoMoratorios,
		ROUND(IFNULL(SUM(ROUND(A.SaldoInteresOrd +
											  A.SaldoInteresAtr +
											  A.SaldoInteresVen +
											  A.SaldoInteresPro +
											  A.SaldoIntNoConta,2)),0), 2) AS totalInteres,
		IFNULL(SUM(ROUND(A.SaldoCapVigente,2)	+
						  ROUND(A.SaldoCapAtrasa,2)	+
						  ROUND(A.SaldoCapVencido,2)	+
						  ROUND(A.SaldoCapVenNExi,2)),0) AS totalCapital,
						  A.CreditoID
		FROM CONDONACIONMASIVA C
        INNER JOIN AMORTICREDITO A
        ON C.CreditoID = A.CreditoID
			WHERE A.Estatus <> 'P'
           AND C.Estatus = 'N'
           AND C.TransaccionID = Par_TransaccionID
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
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr 		:= 999;
			SET Par_ErrMen 		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CONDONACREDITOSMASPRO');
			SET Var_Control		:= 'sqlException' ;
		END;

		OPEN CURSORCONDONACRE;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP
				FETCH CURSORCONDONACRE INTO
				Var_CreditoID,	Var_MontoCom,	Var_MontoMorat,	Var_MontoInt,	Var_MontoCap,
	            Var_TotCom,		Var_TotMorat,	Var_TotInt,		Var_TotCap, 	Var_AmorticreditoID;

	            SET Var_MontoCom	:= IFNULL(Var_MontoCom, Decimal_Cero);
				SET Var_MontoMorat	:= IFNULL(Var_MontoMorat, Decimal_Cero);
	            SET Var_MontoInt	:= IFNULL(Var_MontoInt, Decimal_Cero);
	            SET Var_MontoCap	:= IFNULL(Var_MontoCap, Decimal_Cero);
	            SET Var_TotCom		:= IFNULL(Var_TotCom, Decimal_Cero);
	            SET Var_TotMorat	:= IFNULL(Var_TotMorat, Decimal_Cero);
	            SET Var_TotInt		:= IFNULL(Var_TotInt, Decimal_Cero);
	            SET Var_TotCap		:= IFNULL(Var_TotCap, Decimal_Cero);


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
					Par_Poliza,			Aud_EmpresaID,		Var_FechaSistema, 	Pol_Automatica,		ConceptoCon,
					ConceptoContDesc,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Var_Transaccion);

				IF(Par_NumErr!= Entero_Cero) THEN
					SET Par_ErrMen := CONCAT(Par_ErrMen,' <br>Credito: ',Var_CreditoID);
					LEAVE ManejoErrores;
				END IF;

				SET Var_PuestoID := (SELECT ClavePuestoID FROM USUARIOS AS P WHERE UsuarioID = Aud_Usuario);

				CALL CREQUITASPRO(
					Var_CreditoID,		Aud_Usuario,		Var_PuestoID,				Var_FechaSistema,	Var_MontoCom,
					Var_PorcCom,    Var_MontoMorat,    Var_PorcMorat,		Var_MontoInt,   Var_PorcInt,
					Var_MontoCap,    Var_PorcCap,    Entero_Cero,		Entero_Cero,-- Paleativo
					Par_Poliza,    Par_AltaPolizaNO,   Salida_NO,
					Par_NumErr,    Par_ErrMen,    Aud_EmpresaID,		Aud_Usuario,    Aud_FechaActual,
					Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,    Var_Transaccion);
									
				IF(Par_NumErr!= Entero_Cero) THEN 
					SET Par_ErrMen := CONCAT(Par_ErrMen,' <br>Credito: ',Var_CreditoID);
					LEAVE ManejoErrores;
				END IF;

	            UPDATE CONDONACIONMASIVA
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
					Par_ErrMen	AS ErrMen,
					Var_Control AS Control,
					Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$
