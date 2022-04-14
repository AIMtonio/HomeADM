package crowdfunding.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import crowdfunding.bean.AmortizaFondeoCRWBean;

public class AmortizaFondeoCRWDAO extends BaseDAO{

	public AmortizaFondeoCRWDAO() {
		super();
	}

	/* Lista de Amortizaciones de Fondeo para pantalla calendario de inversionistas */
	public List listaGridAmortizaFondeo(AmortizaFondeoCRWBean AmortizaFondeoCRWBean, int tipoLista) {
		// Query con el Store Procedure
		String query = "call AMORTICRWFONDEOLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				AmortizaFondeoCRWBean.getSolFondeoID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICRWFONDEOLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				AmortizaFondeoCRWBean amortizaCRWBean = new AmortizaFondeoCRWBean();
				amortizaCRWBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				amortizaCRWBean.setFechaInicio(resultSet.getString("FechaInicio"));
				amortizaCRWBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				amortizaCRWBean.setFechaExigible(resultSet.getString("FechaExigible"));
				amortizaCRWBean.setCapital(resultSet.getString("Capital"));
				amortizaCRWBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
				amortizaCRWBean.setEstatus(resultSet.getString("Estatus"));
				amortizaCRWBean.setSaldoCapVigente(resultSet.getString("SaldoCapital"));
				amortizaCRWBean.setSaldoInteres(resultSet.getString("SaldoInteres"));
				amortizaCRWBean.setSaldoMoratorios(resultSet.getString("SaldoIntMoratorio"));
				amortizaCRWBean.setSaldoCapCtaOrden(resultSet.getString("SaldoCapCtaOrden"));
				amortizaCRWBean.setSaldoIntCtaInt(resultSet.getString("SaldoIntCtaOrden"));
				amortizaCRWBean.setTotalSalCapital(resultSet.getString("TotalSalCap"));
				amortizaCRWBean.setTotalSalInteres(resultSet.getString("TotalSalInteres"));
				amortizaCRWBean.setTotalIntMora(resultSet.getString("TotalMoratorio"));
				amortizaCRWBean.setTotalCapCO(resultSet.getString("TotalCapitalCO"));
				amortizaCRWBean.setTotalIntCO(resultSet.getString("TotalInteresCO"));
				amortizaCRWBean.setFechaLiquida(resultSet.getString("FechaLiquida"));
				amortizaCRWBean.setInteresRetener(resultSet.getString("InteresRetener"));

				return amortizaCRWBean;
			}
		});
		return matches;
	}
}