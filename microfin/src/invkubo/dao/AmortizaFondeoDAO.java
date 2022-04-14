package invkubo.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import invkubo.bean.AmortizaFondeoBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

public class AmortizaFondeoDAO extends BaseDAO{

	public AmortizaFondeoDAO() {
		super();
	}
	
	
	
	/* Lista de Amortizaciones de Fondeo para pantalla calendario de inversionistas */
	public List listaGridAmortizaFondeo(AmortizaFondeoBean amortizaFondeoBean, int tipoLista) {
		// Query con el Store Procedure
		 String query = "call AMORTIZAFONDEOLIS(?,?,?,?,?,?,?,?,?);";
				Object[] parametros = { 
						amortizaFondeoBean.getFondeoKuboID(),
						tipoLista,
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(), 
						Constantes.ENTERO_CERO };
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTIZAFONDEOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
							AmortizaFondeoBean amortizaFondeoBean = new AmortizaFondeoBean();
							amortizaFondeoBean.setAmortizacionID(String.valueOf(resultSet.getInt(1)));
							amortizaFondeoBean.setFechaInicio(resultSet.getString(2)); 
							amortizaFondeoBean.setFechaVencimiento(resultSet.getString(3));
							amortizaFondeoBean.setFechaExigible(resultSet.getString(4));
							amortizaFondeoBean.setCapital(resultSet.getString(5));
							amortizaFondeoBean.setInteresGenerado(resultSet.getString(6));
							amortizaFondeoBean.setEstatus(resultSet.getString(7));
							amortizaFondeoBean.setSaldoCapVigente(resultSet.getString(8));
							amortizaFondeoBean.setSaldoInteres(resultSet.getString(9));
							amortizaFondeoBean.setTotalSalCapital(resultSet.getString(10));
							amortizaFondeoBean.setTotalSalInteres(resultSet.getString(11));
							amortizaFondeoBean.setFechaLiquida(resultSet.getString(12));
							return amortizaFondeoBean;
						}
				});

				return matches;
		}

	
}
