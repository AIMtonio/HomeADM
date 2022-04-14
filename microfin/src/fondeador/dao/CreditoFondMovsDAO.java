package fondeador.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import fondeador.bean.CreditoFondMovsBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

public class CreditoFondMovsDAO extends BaseDAO{

	public CreditoFondMovsDAO() {
		super();
	}
	
	/*Muestra los movimientos del Credito pasivo*/
	public List listaPrincipal(final CreditoFondMovsBean creditoFondMovsBean, int tipoLista){
		String query = "call CREDITOFONDMOVSLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros ={
				            creditoFondMovsBean.getCreditoFondeoID(),
				    		tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"CreditoFondMovsDAO.listaPrincipal",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDMOVSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			@Override
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditoFondMovsBean creditoFondMovsBean= new CreditoFondMovsBean();
				creditoFondMovsBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				creditoFondMovsBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
				creditoFondMovsBean.setDescripcion(resultSet.getString("Descripcion"));
				creditoFondMovsBean.setDescripTipMov(resultSet.getString("DescripTipMov"));
				creditoFondMovsBean.setTipoMovFonID(resultSet.getString("TipoMovFonID"));

				creditoFondMovsBean.setNatMovimiento(resultSet.getString("NatMovimiento"));
				creditoFondMovsBean.setNatMovimientoDes(resultSet.getString("NatMovimientoDes"));
				creditoFondMovsBean.setCantidad(resultSet.getString("Cantidad"));
				return creditoFondMovsBean ;
			}
		});
		return matches;
	}
}
