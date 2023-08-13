/*

Cleaning Data in SQL

*/

Select *
from nashville_housing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDate
from nashville_housing

Alter Table nashville_housing
Alter Column SaleDate date



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select *
from nashville_housing
where PropertyAddress is null
order by ParcelID

Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL (A.PropertyAddress, B.PropertyAddress)
from nashville_housing A
Join nashville_housing B
	ON A.ParcelID=B.ParcelID
	AND A.[UniqueID] <> B.[UniqueID]
Where A.PropertyAddress is Null

Update A
Set PropertyAddress =  ISNULL (A.PropertyAddress, B.PropertyAddress)
from nashville_housing A
Join nashville_housing B
	ON A.ParcelID=B.ParcelID
	AND A.[UniqueID] <> B.[UniqueID]
Where A.PropertyAddress is Null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress,
substring(PropertyAddress,1, charindex(',' ,PropertyAddress)-1) as Address,
substring(PropertyAddress, charindex(',' ,PropertyAddress)+1, LEN(PropertyAddress)) as Address
from nashville_housing


Alter Table nashville_housing
Add PropertyAddress_Split nvarchar(255)

Update nashville_housing
Set PropertyAddress_Split=substring(PropertyAddress,1, charindex(',' ,PropertyAddress)-1)

Alter Table nashville_housing
Add PropertyCity_Split nvarchar(255)

Update nashville_housing
Set PropertyCity_Split=substring(PropertyAddress, charindex(',' ,PropertyAddress)+1, LEN(PropertyAddress))

Select *
From nashville_housing

Select OwnerAddress,
	PARSENAME(Replace(OwnerAddress, ',', '.'),3),
	PARSENAME(Replace(OwnerAddress, ',', '.'),2),
	PARSENAME(Replace(OwnerAddress, ',', '.'),1)
From nashville_housing


Alter Table nashville_housing
Add OwnerAddress_Split nvarchar(255)

Update nashville_housing
Set OwnerAddress_Split= PARSENAME(Replace(OwnerAddress, ',', '.'),3)


Alter Table nashville_housing
Add OwnerCity_Split nvarchar(255)

Update nashville_housing
Set OwnerCity_Split= PARSENAME(Replace(OwnerAddress, ',', '.'),2)

Alter Table nashville_housing
Add OwnerState_Split nvarchar(255)

Update nashville_housing
Set OwnerState_Split= PARSENAME(Replace(OwnerAddress, ',', '.'),1)



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select distinct(SoldAsVacant), count(SoldAsVacant)
From nashville_housing
group by SoldAsVacant
order by 2

Select SoldAsVacant,
	Case When SoldAsVacant= 'Y' then 'Yes'
		 When SoldAsVacant= 'N' then 'No'
		 Else SoldAsVacant
		 end
From nashville_housing

Update nashville_housing
Set SoldAsVacant= Case When SoldAsVacant= 'Y' then 'Yes'
		 When SoldAsVacant= 'N' then 'No'
		 Else SoldAsVacant
		 end


		 
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

With RowNumCTE AS(
Select *,
	ROW_NUMBER() over(
	Partition By ParcelId,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 Order by UniqueId)
				 row_num
from nashville_housing)

Delete 
from RowNumCTE
Where row_num>1

Select *
from RowNumCTE
Where row_num>1


Select *
from nashville_housing



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
from nashville_housing

Alter Table nashville_housing
Drop Column PropertyAddress, OwnerAddress, TaxDistrict