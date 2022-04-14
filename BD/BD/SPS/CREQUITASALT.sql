-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREQUITASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREQUITASALT`;
DELIMITER $$

CREATE PROCEDURE `CREQUITASALT`(
    Par_CreditoID       bigint,
    Par_UsuarioID       int,
    Par_PuestoID        varchar(10),
    Par_FechaRegistro   date,
    Par_MontoComisiones decimal(12,2),
    Par_PorceComisiones decimal(12,4),
    Par_MontoMoratorios decimal(12,2),
    Par_PorceMoratorios decimal(12,4),
    Par_MontoInteres    decimal(12,2),
    Par_PorceInteres    decimal(12,4),
    Par_MontoCapital    decimal(12,2),
    Par_PorceCapital    decimal(12,4),
	Par_MontoNotasCargo	DECIMAL(12,2),		-- Parametro del monto de Nota Cargo a condonar
	Par_PorceNotasCargo	DECIMAL(12,4),		-- Parametro del porcentaje Nota Cargo

    Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint      )
TerminaStore: BEGIN


DECLARE Var_ProdCred    int;
DECLARE Var_SaldoCap    decimal(12,2);
DECLARE Var_SaldoInt    decimal(12,2);
DECLARE Var_SaldoMora   decimal(12,2);
DECLARE Var_SaldoAcces  decimal(12,2);
DECLARE Var_NotaCargo	DECIMAL(12,2);	-- Variable Nota Cargo

DECLARE Var_Consecutivo int;
DECLARE Var_DescriPues  char(150);



DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE SalidaNO        char(1);
DECLARE SalidaSI        char(1);
DECLARE Dif_Interes     decimal(12,2);
DECLARE esContingente   VARCHAR(50);
DECLARE Var_Control     VARCHAR(100);


SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET SalidaNO        := 'N';
SET SalidaSI        := 'S';
SET Dif_Interes     := 0.50;
SET esContingente   := "CondonacionCarteraContingente";


ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
   SET Par_NumErr  = 999;
   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
              'Disculpe las molestias que esto le ocasiona. Ref: SP-CREQUITASALT');
   SET Var_Control := 'sqlException' ;

END;

SELECT FechaSistema into Par_FechaRegistro
    FROM PARAMETROSSIS;


        SELECT  ProductoCreditoID,
            (ifnull(SaldCapVenNoExi, 0) + ifnull(SaldoCapVencido, 0) +
             ifnull(SaldoCapAtrasad, 0) + ifnull(SaldoCapVigent, 0)  ),

            (ifnull(SaldoInterOrdin, 0) + ifnull(SaldoInterAtras, 0) +
             ifnull(SaldoInterProvi, 0) + ifnull(SaldoIntNoConta, 0) +
             ifnull(SaldoInterVenc, 0)  ),

            (ifnull(SaldoMoratorios,0) + ifnull(SaldoMoraVencido,0) +
            ifnull(SaldoMoraCarVen,0)),

			(ifnull(SaldComFaltPago, 0) + ifnull(SaldoOtrasComis, 0) +  ifnull(SaldoComServGar, 0) ),
			(ifnull(SaldoNotCargoRev, 0) + ifnull(SaldoNotCargoSinIVA, 0) + ifnull(SaldoNotCargoConIVA, 0))
        INTO

            Var_ProdCred,   Var_SaldoCap, Var_SaldoInt, Var_SaldoMora, Var_SaldoAcces,	Var_NotaCargo
        FROM CREDITOS
        WHERE CreditoID = Par_CreditoID;

SET Var_ProdCred    := ifnull(Var_ProdCred, Entero_Cero);
SET Var_SaldoCap    := ifnull(Var_SaldoCap, Entero_Cero);
SET Var_SaldoInt    := ifnull(Var_SaldoInt, Entero_Cero);
SET Var_SaldoMora   := ifnull(Var_SaldoMora, Entero_Cero);
SET Var_SaldoAcces  := ifnull(Var_SaldoAcces, Entero_Cero);
SET Var_NotaCargo  := ifnull(Var_NotaCargo, Entero_Cero);

SET Var_SaldoInt    := round(Var_SaldoInt, 2);

	IF(Var_ProdCred = Entero_Cero) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '001' AS NumErr,
				'Credito Incorrecto.' AS ErrMen,
				'ProducCreditoID' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Credito Incorrecto' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	SELECT Descripcion into Var_DescriPues
		FROM PUESTOS
		WHERE ClavePuestoID = Par_PuestoID;

	SET Var_DescriPues  := ifnull(Var_DescriPues, Cadena_Vacia);


	IF(Var_DescriPues = Cadena_Vacia) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '002' AS NumErr,
				concat('Puesto Incorrecto. ', Par_PuestoID) AS ErrMen,
				'ClavePuestoID' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'Puesto Incorrecto.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	SET Par_MontoNotasCargo := IFNULL(Par_MontoNotasCargo, Entero_Cero);

	-- Validacion nota cargos
	IF(Par_MontoNotasCargo < Entero_Cero or Par_MontoNotasCargo > Var_NotaCargo) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '003' AS NumErr,
				'Monto de Condonacion de Notas Cargo Incorrecto.' AS ErrMen,
				'MontoComisiones' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'Monto de Condonacion de Notas Cargo Incorrecto.';
			LEAVE TerminaStore;
		END IF;
	END IF;

	SET Par_PorceNotasCargo := IFNULL(Par_PorceNotasCargo, Entero_Cero);

	IF(Par_PorceNotasCargo < Entero_Cero) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '004' AS NumErr,
				'Porcentaje de Notas Cargo Incorrecto.' AS ErrMen,
				'PorceComisiones' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'Porcentaje de Notas Cargo Incorrecto.';
			LEAVE TerminaStore;
		END IF;
	END IF;

	SET Par_MontoComisiones := ifnull(Par_MontoComisiones, Entero_Cero);

	IF(Par_MontoComisiones < Entero_Cero or Par_MontoComisiones > Var_SaldoAcces) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '003' AS NumErr,
				'Monto de Condonacion de Accesorios Incorrecto.' AS ErrMen,
				'MontoComisiones' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'Monto de Condonacion de Accesorios Incorrecto.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	SET Par_PorceComisiones := ifnull(Par_PorceComisiones, Entero_Cero);

	IF(Par_PorceComisiones < Entero_Cero) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '004' AS NumErr,
				'Porcentaje de Accesorios Incorrecto.' AS ErrMen,
				'PorceComisiones' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'Porcentaje de Accesorios Incorrecto.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	SET Par_MontoMoratorios := ifnull(Par_MontoMoratorios, Entero_Cero);

	IF(Par_MontoMoratorios < Entero_Cero or Par_MontoMoratorios > Var_SaldoMora) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '005' AS NumErr,
				'Monto de Condonacion de Moratorios Incorrecto.' AS ErrMen,
				'MontoMoratorios' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'Monto de Condonacion de Moratorios Incorrecto.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	SET Par_PorceMoratorios := ifnull(Par_PorceMoratorios, Entero_Cero);

	IF(Par_PorceMoratorios < Entero_Cero) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '006' AS NumErr,
				'Porcentaje de Moratorios Incorrecto.' AS ErrMen,
				'PorceMoratorios' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := 'Porcentaje de Moratorios Incorrecto.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	SET Par_MontoInteres := ifnull(Par_MontoInteres, Entero_Cero);

	IF(Par_MontoInteres < Entero_Cero or (Par_MontoInteres - Var_SaldoInt > Dif_Interes )) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '007' AS NumErr,
				'Monto de Condonacion de Interes Incorrecto.' AS ErrMen,
				'MontoInteres' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 7;
			SET Par_ErrMen := 'Monto de Condonacion de Interes Incorrecto.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	SET Par_PorceInteres := ifnull(Par_PorceInteres, Entero_Cero);

	IF(Par_PorceInteres < Entero_Cero) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '008' AS NumErr,
				'Porcentaje de Interes Incorrecto.' AS ErrMen,
				'PorceInteres' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 8;
			SET Par_ErrMen := 'Porcentaje de Interes Incorrecto.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	SET Par_MontoCapital := ifnull(Par_MontoCapital, Entero_Cero);

	IF(Par_MontoCapital < Entero_Cero or Par_MontoCapital > Var_SaldoCap) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '009' AS NumErr,
				'Monto de Condonacion de Capital Incorrecto.' AS ErrMen,
				'MontoCapital' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 9;
			SET Par_ErrMen := 'Monto de Condonacion de Capital Incorrecto.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	SET Par_PorceCapital := ifnull(Par_PorceCapital, Entero_Cero);

	IF(Par_PorceCapital < Entero_Cero) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '010' AS NumErr,
				'Porcentaje de Capital Incorrecto.' AS ErrMen,
				'PorceInteres' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 10;
			SET Par_ErrMen := 'Porcentaje de Capital Incorrecto.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	SELECT MAX(Consecutivo) into Var_Consecutivo
		FROM CREQUITAS
		WHERE CreditoID = Par_CreditoID;

	SET Var_Consecutivo := IFNULL(Var_Consecutivo, Entero_Cero);
	SET Var_Consecutivo := Var_Consecutivo + 1;

	INSERT INTO CREQUITAS VALUES(
		Par_CreditoID,			Var_Consecutivo,		Par_UsuarioID,			Par_PuestoID,
		Par_FechaRegistro,		Par_MontoComisiones,	Par_PorceComisiones,	Par_MontoMoratorios,
		Par_PorceMoratorios,	Par_MontoInteres,		Par_PorceInteres,		Par_MontoCapital,
		Par_PorceCapital,		Var_SaldoCap,			Var_SaldoInt,			Var_SaldoMora,
		Var_SaldoAcces,			Var_NotaCargo,			Par_MontoNotasCargo,	Par_PorceNotasCargo,
		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	SET Par_NumErr  := Entero_Cero;
	SET Var_Control := 'creditoID';
	SET Par_ErrMen  := 'Condonacion Realizada Exitosamente.';

END ManejoErrores;  -- End del Handler de Errores

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_CreditoID AS consecutivo;
END IF;


END TerminaStore$$