-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERAGATREALCTA
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERAGATREALCTA`;
DELIMITER $$

CREATE PROCEDURE `GENERAGATREALCTA`(
-- =========================================================
-- ----- SP QUE REALIZA LA ACTUALIZACION DEL GAT REAL-----
-- =========================================================

	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore:BEGIN


DECLARE Salida_SI		CHAR(1);
DECLARE	Decimal_Cero	DECIMAL(12,2);
DECLARE Est_Act			CHAR(1);
DECLARE Est_Blo			CHAR(1);


DECLARE Var_Control		VARCHAR(50);
DECLARE Var_Inflacion	DECIMAL(5,2);


SET	Decimal_Cero	:= 0.0;
SET Salida_SI		:= 'S';
SET Est_Act			:= 'A';
SET Est_Blo			:= 'B';

ManejoErrores:BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr  := 999;
					SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-GENERAGATREALCTA');
					SET Var_Control := 'sqlException';
			END;


		SELECT InflacionProy INTO Var_Inflacion
							FROM INFLACIONACTUAL
							WHERE FechaActualizacion =
								(SELECT MAX(FechaActualizacion)
											FROM INFLACIONACTUAL);

		SET Var_Inflacion := IFNULL(Var_Inflacion,Decimal_Cero);


        UPDATE CUENTASAHO CA INNER JOIN TIPOSCUENTAS TC ON CA.TipoCuentaID = TC.TipoCuentaID
		SET CA.Gat = TC.GatInformativo
		WHERE CA.TipoCuentaID != 1;


			UPDATE CUENTASAHO CTA
				SET GatReal 		= FUNCIONCALCGATREAL(IFNULL(CTA.Gat,Decimal_Cero),Var_Inflacion),
					Usuario         = Aud_Usuario,
					FechaActual     = Aud_FechaActual,
					DireccionIP     = Aud_DireccionIP,
					ProgramaID      = Aud_ProgramaID,
					Sucursal        = Aud_Sucursal,
					NumTransaccion  = Aud_NumTransaccion
				WHERE
						CTA.Estatus IN(Est_Act,Est_Blo);
			-- AJuste_RLAVIDA_14007
			UPDATE INVERSIONES INV
				SET ValorGatReal = FUNCIONCALCGATREAL(IFNULL(INV.ValorGatReal,Decimal_Cero),Var_Inflacion);

			UPDATE CEDES CE
				SET ValorGatReal = FUNCIONCALCGATREAL(IFNULL(CE.ValorGatReal,Decimal_Cero),Var_Inflacion);

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := 'Valor Actualizado Exitosamente';
			SET Var_Control := 'valorGatAct';

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$
