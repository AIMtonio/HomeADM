package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import credito.bean.AmortizacionCreditoBean;
import credito.bean.CreditosMovsBean;

public class CreditosMovsDAO extends BaseDAO{

	
	public CreditosMovsDAO(){
		super();
	}
	
	public List listaGrid(int tipoLista, CreditosMovsBean creditosMovsBean){
		
		String query = "call CREDITOSMOVSLIS(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					creditosMovsBean.getCreditoID(),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosMovsDAO.listaGrid",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
					
					
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMOVSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosMovsBean creditosMovsBean = new CreditosMovsBean();
				creditosMovsBean.setAmortiCreID(resultSet.getString(1));
				creditosMovsBean.setFechaOperacion(resultSet.getString(2)); 
				creditosMovsBean.setDescripcion(resultSet.getString(3));
				creditosMovsBean.setTipoMovCreID(resultSet.getString(4));
				creditosMovsBean.setNatMovimiento(resultSet.getString(5));
				creditosMovsBean.setCantidad(resultSet.getString(6));
				
				
				return creditosMovsBean;
			}
		});
	
		return matches;	
				
	}
}
