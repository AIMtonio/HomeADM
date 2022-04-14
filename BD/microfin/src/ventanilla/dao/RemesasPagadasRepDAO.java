package ventanilla.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import ventanilla.bean.RemesasPagadasRepBean;

public class RemesasPagadasRepDAO extends BaseDAO{
	
	public RemesasPagadasRepDAO(){
		super();
	}
	
	public List reporteExcel(RemesasPagadasRepBean remesasPagadasBean){
		List lista = null;
		try {
			String query = "CALL PAGOREMESASREP (?,?,?,?,?,  ?,	?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(remesasPagadasBean.getRemesadoraID()),
					Utileria.convierteEntero(remesasPagadasBean.getSucursalID()),
					Utileria.convierteEntero(remesasPagadasBean.getUsuarioID()),
					Utileria.convierteFecha(remesasPagadasBean.getFechaInicial()),
					Utileria.convierteFecha(remesasPagadasBean.getFechaFinal()),
					
					Utileria.convierteEntero(remesasPagadasBean.getPresentacion()),

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"RemesasPagadasDAO.reportExcel",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL PAGOREMESASREP (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RemesasPagadasRepBean resultado = new RemesasPagadasRepBean();
					resultado.setFechaDePago(resultSet.getString("FechaDePago"));
					resultado.setRemesadora(resultSet.getString("Remesedora"));
					resultado.setReferencia(resultSet.getString("Referencia"));
					resultado.setSucursal(resultSet.getString("Sucursal"));
					resultado.setCliente(resultSet.getString("Cliente"));
					resultado.setMonto(resultSet.getString("Monto"));
					resultado.setCajero(resultSet.getString("Cajero"));
					resultado.setFormaDePago(resultSet.getString("FormaDePago"));
					resultado.setBilletesMil(resultSet.getString("BilletesMil"));
					resultado.setBilletesQuinientos(resultSet.getString("BilletesQuinientos"));
					resultado.setBilletesDoscientos(resultSet.getString("BilletesDoscientos"));
					resultado.setBilletesCien(resultSet.getString("BilletesCien"));
					resultado.setBilletesCincuenta(resultSet.getString("BilletesCincuenta"));
					resultado.setBilletesVeinte(resultSet.getString("BilletesVeinte"));
					resultado.setMonedas(resultSet.getString("Monedas"));
					resultado.setNoImpresiones(resultSet.getString("NoImpresiones"));
					return resultado;
				}
			});
			lista = matches;
		} catch (Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de remesas pagadas", e);
		}		
		return lista;
	}

}
