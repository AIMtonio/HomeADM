-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIFONDEOAGROGRUPALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIFONDEOAGROGRUPALALT`;

DELIMITER $$
CREATE PROCEDURE `AMORTIFONDEOAGROGRUPALALT`(

	Par_CreditoFondeoID							BIGINT(20),
	Par_TipoGrupo								VARCHAR(2),
	Par_Salida									CHAR(1),
	INOUT Par_NumErr							INT(11),
	INOUT Par_ErrMen							VARCHAR(400),


	Aud_EmpresaID								INT(11),
	Aud_Usuario									INT(11),
	Aud_FechaActual								DATETIME,
	Aud_DireccionIP								VARCHAR(15),

	Aud_ProgramaID								VARCHAR(50),
	Aud_Sucursal								INT(11),
	Aud_NumTransaccion							BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE Var_CicloAmortizaPasivoID			INT(11);
	DECLARE Var_CicloContador 					INT(11);
	DECLARE Var_CicloFechaInicio				DATE;
	DECLARE Var_CicloFechaInicioPas				DATE;
	DECLARE Var_CicloFechaVencim				DATE;
	DECLARE Var_CicloFechaVencimAnt				DATE;
	DECLARE Var_CicloNRegistros 				INT(11);
	DECLARE Var_CicloRegActual					INT(11);
	DECLARE Var_CicloRegMax						INT(11);
	DECLARE Var_CicloRegMin						INT(11);
	DECLARE Var_Control							VARCHAR(100);
	DECLARE Var_NO								CHAR(1);
	DECLARE Var_SI								CHAR(1);



	DECLARE	Cadena_Vacia						CHAR(1);
	DECLARE	Decimal_Cero						DECIMAL(12,2);
	DECLARE	Entero_Cero							INT;
	DECLARE	Entero_Uno							INT;
	DECLARE	Fecha_Vacia							DATE;
	DECLARE	Salida_NO							CHAR(1);
	DECLARE	Salida_SI							CHAR(1);
	DECLARE Constante_NO						CHAR(1);
	DECLARE Cons_Estatus_Inactiva				CHAR(1);
	DECLARE Cons_EstatusNoDesembolsada			CHAR(1);
	DECLARE Cons_FechaPactada					CHAR(1);
	DECLARE TipoGrupo_NoAplica					VARCHAR(2);
	DECLARE TipoGrupo_NoFormal					VARCHAR(2);
	DECLARE TipoGrupo_Global					VARCHAR(2);


	SET Var_NO									:= 'N';
	SET Var_SI									:= 'S';


	SET Aud_FechaActual							:= NOW();
	SET Cadena_Vacia							:= '';
	SET Cons_Estatus_Inactiva					:= 'I';
	SET Cons_EstatusNoDesembolsada				:= 'N';
	SET Cons_FechaPactada						:= 'P';
	SET Constante_NO							:= 'N';
	SET Decimal_Cero							:= 0.00;
	SET Entero_Cero								:= 0;
	SET Entero_Uno								:= 1;
	SET Fecha_Vacia								:= '1900-01-01';
	SET Salida_NO								:= 'N';
	SET Salida_SI								:= 'S';
	SET TipoGrupo_Global						:= 'G';
	SET TipoGrupo_NoAplica						:= '';
	SET TipoGrupo_NoFormal						:= 'NF';
	SET @nregistro_tempagro						:= 0;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT(Par_ErrMen,' El SAFI ha tenido un problema al concretar la operación. ',
			'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTIFONDEOAGROGRUPALALT');
			SET Var_Control := 'sqlException';
		END;


		DELETE FROM TEMAMORTICREDITOAGRO WHERE CreditoFondeoID = Par_CreditoFondeoID;


		IF(Par_TipoGrupo = TipoGrupo_Global) THEN

			INSERT INTO TEMAMORTICREDITOAGRO(
				Transaccion,									CreditoID,				AmortizacionID,				CreditoFondeoID,			AmortizaPasivoID,
				NRegistro,										FechaInicio,			FechaVencim,				Capital,					EmpresaID,
				Usuario,										FechaActual,			DireccionIP,				ProgramaID,					Sucursal,
				NumTransaccion)
			  SELECT
				Aud_NumTransaccion,								CC.CreditoID,			CC.AmortizacionID,			CC.CreditoFondeoID,			0,
				@nregistro_tempagro := @nregistro_tempagro +1,	CC.FechaInicio,			CC.FechaVencim,				CC.Capital,					Aud_EmpresaID,
				Aud_Usuario,									Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,
				Aud_NumTransaccion
				FROM
				(SELECT
				Amo.CreditoID,			Amo.AmortizacionID,			Rel.CreditoFondeoID,		0,
				Amo.FechaInicio,		Amo.FechaVencim,			Amo.Capital
				FROM
					AMORTICREDITOAGRO AS Amo INNER JOIN RELCREDPASIVOAGRO AS Rel ON Amo.CreditoID = Rel.CreditoID
					WHERE
						Rel.CreditoFondeoID = Par_CreditoFondeoID
						ORDER BY Amo.FechaVencim) AS CC
				ORDER BY FechaVencim ASC;


			SET Var_CicloNRegistros 				:= (SELECT MAX(Tem.NRegistro)
															FROM TEMAMORTICREDITOAGRO AS Tem
															WHERE Tem.CreditoFondeoID = Par_CreditoFondeoID AND Transaccion = Aud_NumTransaccion);
			SET Var_CicloNRegistros					:= IFNULL(Var_CicloNRegistros, Entero_Cero);
			SET Var_CicloContador					:= Entero_Uno;
			SET Var_CicloAmortizaPasivoID 			:= Entero_Uno;
			SET Var_CicloFechaInicioPas				:= Fecha_Vacia;
			SET Var_CicloFechaVencimAnt				:= Fecha_Vacia;

			WHILE (Var_CicloContador <= Var_CicloNRegistros) DO
				SELECT
					Tem.NRegistro,			Tem.FechaInicio,				Tem.FechaVencim
					INTO
					Var_CicloRegActual,		Var_CicloFechaInicio,				Var_CicloFechaVencim
					FROM
						TEMAMORTICREDITOAGRO AS Tem
							WHERE Tem.CreditoFondeoID = Par_CreditoFondeoID
							AND Tem.NRegistro = Var_CicloContador;

				IF(Var_CicloFechaVencimAnt!=Var_CicloFechaVencim) THEN
					IF(Var_CicloFechaInicioPas = Fecha_Vacia) THEN

						SET Var_CicloFechaInicioPas := (SELECT MIN(FechaInicio) FROM TEMAMORTICREDITOAGRO AS Tem
															WHERE Tem.CreditoFondeoID = Par_CreditoFondeoID
																AND Transaccion = Aud_NumTransaccion);
					  ELSE
							SET Var_CicloFechaInicioPas		:= Var_CicloFechaVencimAnt;
					END IF;

					SET Var_CicloAmortizaPasivoID	:= Var_CicloAmortizaPasivoID + Entero_Uno;
					SET Var_CicloFechaVencimAnt		:= Var_CicloFechaVencim;
				END IF;

				UPDATE TEMAMORTICREDITOAGRO AS Tem SET
					AmortizaPasivoID = Var_CicloAmortizaPasivoID,
					FechaInicio = Var_CicloFechaInicioPas
					WHERE Tem.CreditoFondeoID = Par_CreditoFondeoID
						AND Transaccion = Aud_NumTransaccion
						AND Tem.NRegistro = Var_CicloContador;

				SET Var_CicloContador					:= Var_CicloContador + Entero_Uno;
			END WHILE;


			INSERT INTO AMORTIZAFONDEOAGRO(
				CreditoFondeoID,				AmortizacionID,				FechaInicio,			FechaVencimiento,		FechaExigible,
				FechaLiquida,					Estatus,					Capital,				Interes,					IVAInteres,
				SaldoCapVigente,				SaldoCapAtrasad,			SaldoInteresAtra,		SaldoInteresPro,			SaldoIVAInteres,
				SaldoMoratorios,				SaldoIVAMora,				SaldoComFaltaPa,		SaldoIVAComFalP,			SaldoOtrasComis,
				SaldoIVAComisi,					ProvisionAcum,				SaldoCapital,			SaldoRetencion,				Retencion,
				EstatusDesembolso,				MontoPendDesembolso,		TipoCalculoInteres,		EmpresaID,					Usuario,
				FechaActual,					DireccionIP,				ProgramaID,				Sucursal,					NumTransaccion)
			SELECT
				Tem.CreditoFondeoID,			Tem.AmortizaPasivoID,		MIN(Tem.FechaInicio),	MAX(Tem.FechaVencim),		MAX(Tem.FechaVencim),
				Fecha_Vacia,					Cons_Estatus_Inactiva,		SUM(Tem.Capital),		Entero_Cero,				Entero_Cero,
				Entero_Cero,					Entero_Cero,				Entero_Cero,			Entero_Cero,				Entero_Cero,
				Entero_Cero,					Entero_Cero,				Entero_Cero,			Entero_Cero,				Entero_Cero,
				Entero_Cero,					Entero_Cero,				Entero_Cero,			Entero_Cero,				Entero_Cero,
				Cons_EstatusNoDesembolsada,		SUM(Tem.Capital),			Cons_FechaPactada,		Aud_EmpresaID,				Aud_Usuario,
				Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
				FROM TEMAMORTICREDITOAGRO AS Tem
					WHERE CreditoFondeoID = Par_CreditoFondeoID
					GROUP BY CreditoFondeoID,AmortizaPasivoID;

		ELSEIF(Par_TipoGrupo =TipoGrupo_NoFormal) THEN


			INSERT INTO AMORTIZAFONDEOAGRO(
				CreditoFondeoID,				AmortizacionID,			FechaInicio,			FechaVencimiento,			FechaExigible,
				FechaLiquida,					Estatus,				Capital,				Interes,					IVAInteres,
				SaldoCapVigente,				SaldoCapAtrasad,		SaldoInteresAtra,		SaldoInteresPro,			SaldoIVAInteres,
				SaldoMoratorios,				SaldoIVAMora,			SaldoComFaltaPa,		SaldoIVAComFalP,			SaldoOtrasComis,
				SaldoIVAComisi,					ProvisionAcum,			SaldoCapital,			SaldoRetencion,				Retencion,
				EstatusDesembolso,				MontoPendDesembolso,	TipoCalculoInteres,		EmpresaID,					Usuario,
				FechaActual,					DireccionIP,			ProgramaID,				Sucursal,					NumTransaccion)
				SELECT
				Par_CreditoFondeoID,			Amo.AmortizacionID,		Amo.FechaInicio,		Amo.FechaVencim,			Amo.FechaExigible,
				Amo.FechaLiquida,				Amo.Estatus,			SUM(Amo.Capital),		Entero_Cero,				Entero_Cero,
				Entero_Cero,					Entero_Cero,			Entero_Cero,			Entero_Cero,				Entero_Cero,
				Entero_Cero,					Entero_Cero,			Entero_Cero,			Entero_Cero,				Entero_Cero,
				Entero_Cero,					Entero_Cero,			Entero_Cero,			Entero_Cero,				Entero_Cero,
				'N',							SUM(Amo.Capital),		MAX(TipoCalculoInteres),Aud_EmpresaID,				Aud_Usuario,
				Aud_FechaActual,				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
				FROM AMORTICREDITOAGRO AS Amo INNER JOIN RELCREDPASIVOAGRO AS Rel ON Amo.CreditoID = Rel.CreditoID AND IFNULL(Amo.TipoCalculoInteres,Cadena_Vacia) <> Cadena_Vacia
					WHERE Rel.CreditoFondeoID = Par_CreditoFondeoID
						GROUP BY Amo.AmortizacionID, 	Amo.FechaInicio, 	Amo.FechaVencim,		Amo.FechaExigible,
								 Amo.FechaLiquida,		Amo.Estatus,		Amo.TipoCalculoInteres
						ORDER BY FechaInicio,FechaVencim;
		END IF;


		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= CONCAT('Credito Pasivo Agregado Exitosamente: ',CONVERT(Par_CreditoFondeoID,CHAR));
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr 	AS NumErr,
			Par_ErrMen	AS ErrMen,
			'creditoFondeoID' AS control,
			Par_CreditoFondeoID AS consecutivo,
			Par_CreditoFondeoID AS CampoGenerico;
	END IF;
END TerminaStore$$