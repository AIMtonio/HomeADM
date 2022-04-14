-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOCIERREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECASTIGOCIERREPRO`;
DELIMITER $$

CREATE PROCEDURE `CRECASTIGOCIERREPRO`(
	Par_Fecha			DATE,	
	Par_Salida			CHAR(1),
	Par_NumErr			INT,
	Par_ErrMen			VARCHAR(400),

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore:BEGIN
-- Declaracion de Variables
DECLARE Var_CreditoID			BIGINT(20);
DECLARE Var_DiasCastAuto		INT(11);
DECLARE Var_Control				VARCHAR(80);
DECLARE Var_Contador			INT;

DECLARE	Var_FechaBatch			DATE;
DECLARE	Var_FecBitaco 			DATETIME;
DECLARE	Var_MinutosBit 			INT(11);
DECLARE Var_TotalRegs			INT(11);

-- Declaracion de Constantes
DECLARE Entero_Cero				INT(11);
DECLARE ObservCastigo			VARCHAR(150);
DECLARE MotivoCastID			INT(11);
DECLARE Es_Vigente				CHAR(1);
DECLARE Es_Vencido				CHAR(1);
DECLARE Es_Atrasado				CHAR(1);
DECLARE Pro_CastigoAut			INT(11);
DECLARE Str_NO					CHAR(1);
DECLARE Str_SI					CHAR(1);


-- Asignacion de constantes
SET Str_NO						:= 'N';				-- Constante NO.
SET Str_SI						:= 'S';				-- Constante SI.

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECASTIGOCIERREPRO');
		SET Var_Control:= 'sqlException' ;
	END;

	-- Asignacion de constantes
	SET Entero_Cero				:=0;			-- Entero Cero
	SET ObservCastigo			:=CONCAT('Castigo Automatico de Credito por Superar el Parametro de ',CONVERT(Var_DiasCastAuto, CHAR), ' Dias de Mora');
	SET MotivoCastID			:=4;			-- Motivo de Castigo correcponde con MOTIVOSCASTIGO
	SET Es_Vigente				:='V'; 			-- Estatus Vigente
	SET Es_Vencido				:='B';			-- Estatus Vencido
	SET Es_Atrasado				:='A';			-- Estatus Vencido

	SET Pro_CastigoAut			:=206;			-- Procesi Batch Castigo Automatico de Cartera
	SET Var_FecBitaco 			:= NOW();
	SET Aud_FechaActual			:=NOW();

	SELECT DiasCastigoAuto INTO Var_DiasCastAuto
		FROM PARAMETROSSIS LIMIT 1;

	SET Var_DiasCastAuto	:= IFNULL(Var_DiasCastAuto, Entero_Cero);

	IF(IFNULL(Var_DiasCastAuto, Entero_Cero) > Entero_Cero)THEN
		
		DELETE FROM TMPCREDATRASADOS WHERE NumTransaccion = Aud_NumTransaccion;

		SET @Var_ConsID := Entero_Cero;

		INSERT INTO TMPCREDATRASADOS (
			TmpID,
			FechaExigible, 	 TotalAplicar, 	 CreditoID,  	 EmpresaID, 	 Usuario,
			FechaActual,   	 DireccionIP,  	 ProgramaID, 	 Sucursal,  	 NumTransaccion)
		SELECT 
			(@Var_ConsID := @Var_ConsID + 1),
			IFNULL(MIN(FechaExigible),Par_Fecha )AS FechaExigible, 
							SUM(amo.SaldoCapVigente) + SUM(amo.SaldoCapAtrasa) + SUM(SaldoCapVencido)+
							SUM(amo.SaldoCapVenNExi)+ SUM(amo.SaldoInteresOrd) + SUM(SaldoInteresAtr)+
							SUM(SaldoInteresVen) + SUM(SaldoInteresPro) + SUM(SaldoIntNoConta) AS TotalAplicar,
							CreditoID, 			Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
				FROM AMORTICREDITO amo
					WHERE FechaExigible <= Par_Fecha
						AND (amo.Estatus	=  Es_Vigente		
						OR	amo.Estatus		=  Es_Vencido
						OR	amo.Estatus		=  Es_Atrasado)	
						GROUP BY CreditoID;

		SET Var_TotalRegs := (SELECT COUNT(*) FROM TMPFONDEOCRW WHERE NumTransaccion = Aud_NumTransaccion);
		SET Var_TotalRegs := IFNULL(Var_TotalRegs, Entero_Cero);

		SET Var_Contador := 1;

		WHILE(Var_Contador <= Var_TotalRegs)DO

			SELECT CreditoID INTO  Var_CreditoID
			FROM TMPCREDATRASADOS
			WHERE 	TmpID = Var_Contador
				AND NumTransaccion = Aud_NumTransaccion;

			CALL CRECASTIGOPRO(
					Var_CreditoID,	MotivoCastID,	ObservCastigo,		SalidaNO,			Par_NumErr,
					Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF(Var_NumError != Entero_Cero) THEN
		         LEAVE ManejoErrores;
		    END IF;

			SET Var_Contador := Var_Contador + 1;
		END WHILE;

	END IF;


	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(
		Pro_CastigoAut, 	Par_Fecha,			Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Cadena_Vacia AS Control,
			Par_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$